import 'package:flutter/material.dart';
import 'package:english/core/theme/app_colors.dart';
import 'package:english/core/theme/app_typography.dart';
import 'package:english/core/theme/app_spacing.dart';
import '../core/app_icons.dart';
import '../global_widget/app_bar.dart';
import '../global_variable.dart';
import '../db/db/shared_preferences.dart';
import 'support_page.dart';
import 'about.dart';

class SettingsPage extends StatefulWidget {
  final bool isTab;
  const SettingsPage({super.key, this.isTab = false});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: appbar(
        context,
        left: widget.isTab
            ? const SizedBox(width: 22)
            : AppIcons.svg(AppIcons.arrowLeft,
                size: 22, color: AppColors.textPrimaryDark),
        center: Text(
          "Ayarlar",
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.textPrimaryDark,
          ),
        ),
        leftWidgetOnClik: () => widget.isTab ? null : Navigator.pop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.pageVerticalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Dil Section ---
              _sectionHeader("Dil"),
              const SizedBox(height: AppSpacing.sm),
              _buildLanguageToggle(),

              const SizedBox(height: AppSpacing.xxxl),

              // --- Genel Section ---
              _sectionHeader("Genel"),
              const SizedBox(height: AppSpacing.sm),
              _buildSettingsTile(
                icon: AppIcons.heart,
                iconColor: const Color(0xFFD4A853),
                title: "Bizi Destekle",
                subtitle: "Uygulamayı geliştirmemize yardımcı olun",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SupportPage()),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildSettingsTile(
                icon: AppIcons.circleInfo,
                iconColor: AppColors.primary,
                title: "Hakkında",
                subtitle: "Uygulama ve geliştirici bilgileri",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AbaoutPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs),
      child: Text(
        title,
        style: AppTypography.labelMedium.copyWith(
          color: AppColors.textTertiaryDark,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildLanguageToggle() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: Center(
              child: AppIcons.svg(AppIcons.book,
                  size: 20, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ders Dili",
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Soru hangi dilde gösterilsin",
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiaryDark,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: AppSpacing.borderRadiusSm,
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Row(
              children: [
                _langOption("TR", Lang.tr),
                _langOption("EN", Lang.eng),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _langOption(String label, Lang lang) {
    final isSelected = chooeseLang == lang;
    return GestureDetector(
      onTap: () {
        setState(() {
          chooeseLang = lang;
        });
        SP.write('lang', lang == Lang.eng);
      },
      child: Container(
        width: 48,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: AppSpacing.borderRadiusSm,
        ),
        child: Text(
          label,
          style: AppTypography.titleMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondaryDark,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required String icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusMd,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: Center(
                child: AppIcons.svg(icon, size: 20, color: iconColor),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiaryDark,
                    ),
                  ),
                ],
              ),
            ),
            AppIcons.svg(AppIcons.chevronRight,
                size: 16, color: AppColors.textTertiaryDark),
          ],
        ),
      ),
    );
  }
}
