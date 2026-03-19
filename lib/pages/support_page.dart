import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../global_widget/app_bar.dart';
import '../provider/purchase_provider.dart';

final purchaseProvider = ChangeNotifierProvider((ref) => PurchaseProvider());

class SupportPage extends ConsumerStatefulWidget {
  const SupportPage({super.key});

  @override
  ConsumerState<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends ConsumerState<SupportPage> {
  String? _loadingProductId;

  static const _blue = Color(0xff3574C3);
  static const _light = Color(0xffF3FBF8);
  static const _pink = Color(0xffCC3366);
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
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    };
  }

  @override
  void dispose() {
    ref.read(purchaseProvider).onPurchaseSuccess = null;
    ref.read(purchaseProvider).onPurchaseError = null;
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
          const SnackBar(content: Text('Ürün henüz yüklenemedi, lütfen tekrar deneyin.')),
        );
      }
    }
  }

  void _showSuccessDialog() {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _pink.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svg/circle_check.svg',
                    width: 44,
                    height: 44,
                    colorFilter: const ColorFilter.mode(_pink, BlendMode.srcIn),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Teşekkürler!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: _blue,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Desteğiniz için çok teşekkür ederiz!\nUygulamayı geliştirmemize yardımcı oluyorsunuz.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff666666),
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
                    backgroundColor: _blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Tamam',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
      backgroundColor: _blue,
      appBar: appbar(
        context,
        left: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
        center: const Text(
          "Bizi Destekle",
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
        ),
        leftWidgetOnClik: () => Navigator.pop(context),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: _light,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: provider.loading
            ? const Center(child: CircularProgressIndicator(color: _blue))
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Header
                    _buildHeader(),

                    const SizedBox(height: 24),

                    // Donation cards
                    _buildDonationCard(
                      title: 'Küçük Destek',
                      subtitle: 'Bir kahve ısmarla',
                      svgPath: 'assets/svg/mug_hot.svg',
                      color: const Color(0xffA0522D),
                      productId: 'vocapp_support_small',
                    ),
                    const SizedBox(height: 14),
                    _buildDonationCard(
                      title: 'Orta Destek',
                      subtitle: 'Geliştirmemize katkıda bulun',
                      svgPath: 'assets/svg/hand_holding_heart.svg',
                      color: _pink,
                      productId: 'vocapp_support_medium',
                    ),
                    const SizedBox(height: 14),
                    _buildDonationCard(
                      title: 'Büyük Destek',
                      subtitle: 'Büyük bir hediye ver',
                      svgPath: 'assets/svg/gift.svg',
                      color: _blue,
                      productId: 'vocapp_support_large',
                    ),

                    const SizedBox(height: 32),

                    // Footer
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/heart_solid.svg',
                            width: 14,
                            height: 14,
                            colorFilter: const ColorFilter.mode(_pink, BlendMode.srcIn),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Desteğiniz için teşekkür ederiz!',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff999999),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_blue, Color(0xff2A5FA0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _blue.withValues(alpha: 0.35),
            blurRadius: 20,
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
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/svg/hand_holding_heart.svg',
                width: 32,
                height: 32,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Bizi Destekle',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Uygulamayı geliştirmemize yardımcı olun.\nDesteğiniz yeni özellikler ve iyileştirmeler için kullanılacak.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.85),
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
    required String productId,
  }) {
    final isLoading = _loadingProductId == productId;
    final price = _getPrice(productId);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.12), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            // Icon
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
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
            const SizedBox(width: 16),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xff222222),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Color(0xff999999),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    price,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),

            // Button
            SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: isLoading ? null : () => _handlePurchase(productId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: color.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
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
                    : const Text(
                        'Destek Ol',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
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
