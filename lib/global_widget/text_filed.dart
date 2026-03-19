import 'package:flutter/material.dart';
import 'package:english/core/theme/app_colors.dart';
import 'package:english/core/theme/app_typography.dart';
import 'package:english/core/theme/app_spacing.dart';

Column textFieldBuilder(
    {int height = 40,
    Color borderColor = AppColors.primary,
    bool editting = true,
    EdgeInsets? padding,
    required TextEditingController? textEditingController,
    Widget? icon,
    String? hindText,
    TextAlign textAlign = TextAlign.center}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 15, right: 15),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: borderColor,
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: Container(
              height: double.parse(height.toString()),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: TextField(
                  enabled: editting,
                  keyboardType: TextInputType.name,
                  maxLines: 1,
                  textAlign: textAlign,
                  controller: textEditingController,
                  cursorColor: AppColors.primary,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimaryDark,
                    decoration: TextDecoration.none,
                  ),
                  decoration: InputDecoration(
                    icon: icon != null
                        ? IconTheme(
                            data: const IconThemeData(
                              color: AppColors.textSecondaryDark,
                            ),
                            child: icon,
                          )
                        : null,
                    border: InputBorder.none,
                    hintText: hindText,
                    hintStyle: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textTertiaryDark,
                    ),
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    ],
  );
}
