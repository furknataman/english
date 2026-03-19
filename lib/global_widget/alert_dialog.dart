import 'package:flutter/material.dart';
import 'package:english/core/theme/app_colors.dart';
import 'package:english/core/theme/app_typography.dart';
import 'package:english/core/theme/app_spacing.dart';

void alertDialog(BuildContext context, Function functionLeft, Function functionRight,
    String titleText, String bodyText) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          height: 240,
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border.all(
              color: AppColors.borderDark,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.25,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Container(
                      height: 5.0,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(2.5),
                        ),
                        color: AppColors.textTertiaryDark,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    titleText,
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    bodyText,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textSecondaryDark,
                            side: const BorderSide(
                              color: AppColors.borderDark,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppSpacing.borderRadiusMd,
                            ),
                          ),
                          onPressed: () {
                            functionLeft();
                          },
                          child: Text(
                            'İptal',
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.textSecondaryDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppSpacing.borderRadiusMd,
                            ),
                          ),
                          onPressed: () {
                            functionRight();
                          },
                          child: Text(
                            'Onayla',
                            style: AppTypography.labelLarge.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        );
      });
}
