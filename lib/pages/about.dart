import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:english/core/theme/app_colors.dart';
import 'package:english/core/theme/app_typography.dart';
import 'package:english/core/theme/app_spacing.dart';
import '../core/app_icons.dart';
import '../global_widget/app_bar.dart';
import '../provider/version.dart';

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

class AbaoutPage extends ConsumerWidget {
  AbaoutPage({super.key});
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'furknataman@gmail.com',
    query: encodeQueryParameters(<String, String>{
      'subject': 'VOCAPP HK.',
    }),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? version = ref.watch(versionProvider).value;
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: appbar(
        context,
        left: AppIcons.svg(AppIcons.arrowLeft,
            size: 22, color: AppColors.textPrimaryDark),
        center: Text(
          "Hakkında",
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.textPrimaryDark,
          ),
        ),
        leftWidgetOnClik: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: AppSpacing.pagePadding,
            child: Column(
              children: [
                const Spacer(flex: 2),
                // Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cardDark,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    child: Image.asset("assets/images/logo.png", height: 70),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                // App name
                Text(
                  "VocApp",
                  style: AppTypography.displayLarge.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  "İstediğini Öğren",
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  width: 60,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: AppSpacing.borderRadiusSm,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                // Description
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: AppSpacing.borderRadiusMd,
                    border: Border.all(color: AppColors.borderDark),
                  ),
                  child: Text(
                    "Bu uygulama 2022 yılında Furkan ATAMAN tarafından İngilizce kelime öğrenmek isteyenler için geliştirildi.",
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textSecondaryDark,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(flex: 3),
                // Version
                if (version != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: AppSpacing.borderRadiusXl,
                      border: Border.all(color: AppColors.borderDark),
                    ),
                    child: Text(
                      "v$version",
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.textTertiaryDark,
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
                // Email link
                InkWell(
                  onTap: () async {
                    launchUrl(emailLaunchUri);
                  },
                  borderRadius: AppSpacing.borderRadiusSm,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Text(
                      "furknataman@gmail.com",
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
