import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:english/core/theme/app_colors.dart';
import 'package:english/core/theme/app_typography.dart';
import 'package:english/core/theme/app_spacing.dart';
import '../global_widget/app_bar.dart';
import '../core/app_icons.dart';
import '../provider/purchase_provider.dart';

final purchaseProvider = ChangeNotifierProvider((ref) => PurchaseProvider());

class SupportPage extends ConsumerStatefulWidget {
  const SupportPage({super.key});

  @override
  ConsumerState<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends ConsumerState<SupportPage> {
  String? _loadingProductId;

  static const Map<String, String> _fallbackPrices = {
    'vocapp_support_small': '₺29,99',
    'vocapp_support_medium': '₺59,99',
    'vocapp_support_large': '₺109,99',
  };

  @override
  void initState() {
    super.initState();
    final provider = ref.read(purchaseProvider);
    provider.initStore();
    provider.onPurchaseSuccess = (productId) {
      if (mounted) {
        setState(() => _loadingProductId = null);
        _showSuccessDialog();
      }
    };
    provider.onPurchaseError = (error) {
      if (mounted) {
        setState(() => _loadingProductId = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusSm),
          ),
        );
      }
    };
  }

  late final PurchaseProvider _provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _provider = ref.read(purchaseProvider);
  }

  @override
  void dispose() {
    _provider.onPurchaseSuccess = null;
    _provider.onPurchaseError = null;
    super.dispose();
  }

  String _getPrice(String productId) {
    final product = ref.read(purchaseProvider).getProductById(productId);
    return product?.price ?? _fallbackPrices[productId] ?? '';
  }

  Future<void> _handlePurchase(String productId) async {
    if (_loadingProductId != null) return;
    setState(() => _loadingProductId = productId);

    final provider = ref.read(purchaseProvider);
    final product = provider.getProductById(productId);

    if (product != null) {
      final success = await provider.buyProduct(product);
      if (!success && mounted) {
        setState(() => _loadingProductId = null);
      }
    } else {
      if (mounted) {
        setState(() => _loadingProductId = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Ürün henüz yüklenemedi, lütfen tekrar deneyin.'),
            backgroundColor: AppColors.cardDarkElevated,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusSm),
          ),
        );
      }
    }
  }

  void _showSuccessDialog() {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusXl),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svg/circle_check.svg',
                    width: 44,
                    height: 44,
                    colorFilter: const ColorFilter.mode(
                        AppColors.gold, BlendMode.srcIn),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Teşekkürler!',
                style: AppTypography.headlineLarge.copyWith(
                  color: AppColors.gold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Desteğiniz için çok teşekkür ederiz!\nUygulamayı geliştirmemize yardımcı oluyorsunuz.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondaryDark,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppSpacing.borderRadiusMd,
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Tamam',
                    style: AppTypography.titleLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(purchaseProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: appbar(
        context,
        left: AppIcons.svg(AppIcons.arrowLeft,
            size: 22, color: AppColors.textPrimaryDark),
        center: Text(
          "Bizi Destekle",
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.textPrimaryDark,
          ),
        ),
        leftWidgetOnClik: () => Navigator.pop(context),
      ),
      body: provider.loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: AppSpacing.xxl),
                  _buildDonationCard(
                    title: 'Küçük Destek',
                    subtitle: 'Bir kahve ismarla',
                    svgPath: 'assets/svg/mug_hot.svg',
                    color: const Color(0xFFA0522D),
                    accentColor: const Color(0xFFCD853F),
                    productId: 'vocapp_support_small',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildDonationCard(
                    title: 'Orta Destek',
                    subtitle: 'Geliştirmemize katkıda bulun',
                    svgPath: 'assets/svg/hand_holding_heart.svg',
                    color: AppColors.gold,
                    accentColor: AppColors.goldLight,
                    productId: 'vocapp_support_medium',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildDonationCard(
                    title: 'Büyük Destek',
                    subtitle: 'Büyük bir hediye ver',
                    svgPath: 'assets/svg/gift.svg',
                    color: AppColors.primary,
                    accentColor: AppColors.primaryLight,
                    productId: 'vocapp_support_large',
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/heart_solid.svg',
                          width: 14,
                          height: 14,
                          colorFilter: const ColorFilter.mode(
                              AppColors.gold, BlendMode.srcIn),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Desteğiniz için teşekkür ederiz!',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.textTertiaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.xxl, AppSpacing.xl, 0),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A3545), AppColors.cardDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppSpacing.borderRadiusXl,
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/svg/hand_holding_heart.svg',
                width: 32,
                height: 32,
                colorFilter: const ColorFilter.mode(
                    AppColors.gold, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Bizi Destekle',
            style: AppTypography.headlineLarge.copyWith(
              color: AppColors.textPrimaryDark,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Uygulamayı geliştirmemize yardımcı olun.\nDesteğiniz yeni özellikler ve iyileştirmeler için kullanılacak.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondaryDark,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDonationCard({
    required String title,
    required String subtitle,
    required String svgPath,
    required Color color,
    required Color accentColor,
    required String productId,
  }) {
    final isLoading = _loadingProductId == productId;
    final price = _getPrice(productId);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppSpacing.borderRadiusLg,
        border:
            Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            // Icon
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Center(
                child: SvgPicture.asset(
                  svgPath,
                  width: 26,
                  height: 26,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiaryDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    price,
                    style: AppTypography.headlineSmall.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            // Button
            SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed:
                    isLoading ? null : () => _handlePurchase(productId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: color.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18),
                  elevation: 0,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        'Destek Ol',
                        style: AppTypography.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
