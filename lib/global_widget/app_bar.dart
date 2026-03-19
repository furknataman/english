import 'package:flutter/material.dart';
import 'package:english/core/theme/app_colors.dart';
import 'package:english/core/theme/app_typography.dart';

PreferredSize appbar(BuildContext context,
    {required Widget? left, Widget? center, Widget? right, Function? leftWidgetOnClik}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(50),
    child: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.backgroundDark,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width * 0.2,
            child: InkWell(
              onTap: () => leftWidgetOnClik!(),
              splashColor: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: DefaultTextStyle(
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textPrimaryDark,
                ),
                child: IconTheme(
                  data: const IconThemeData(
                    color: AppColors.textPrimaryDark,
                  ),
                  child: left ?? const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.5,
            child: DefaultTextStyle(
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimaryDark,
              ),
              child: center ?? const SizedBox.shrink(),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            width: MediaQuery.of(context).size.width * 0.2,
            child: DefaultTextStyle(
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textPrimaryDark,
              ),
              child: IconTheme(
                data: const IconThemeData(
                  color: AppColors.textPrimaryDark,
                ),
                child: right ?? const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
