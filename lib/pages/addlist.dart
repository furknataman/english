import 'package:english/global_widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../core/app_icons.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/theme/app_spacing.dart';
import '../provider/add_list.dart';

final addListConfig = ChangeNotifierProvider((ref) => AddListProvider());

class AddList extends ConsumerStatefulWidget {
  const AddList({super.key});

  @override
  ConsumerState<AddList> createState() => _AddListState();
}

class _AddListState extends ConsumerState<AddList> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      ref.read<AddListProvider>(addListConfig).getField();
    });
  }

  @override
  Widget build(BuildContext context) {
    final addList = ref.watch<AddListProvider>(addListConfig);
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: appbar(
        context,
        left: AppIcons.svg(AppIcons.arrowLeft,
            size: 22, color: AppColors.textPrimaryDark),
        center: Text("Liste Oluştur",
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.textPrimaryDark,
            )),
        leftWidgetOnClik: () => {Navigator.pop(context)},
      ),
      body: SafeArea(
        child: Column(children: [
          // List name input
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, 0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: AppSpacing.borderRadiusMd,
                border: Border.all(color: AppColors.borderDark, width: 1),
              ),
              child: TextField(
                controller: addList.listName,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textPrimaryDark,
                ),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child:
                        AppIcons.svg(AppIcons.list, size: 18, color: AppColors.primary),
                  ),
                  prefixIconConstraints:
                      const BoxConstraints(minWidth: 0, minHeight: 0),
                  hintText: "Liste Adı",
                  hintStyle: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textTertiaryDark,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                ),
              ),
            ),
          ),

          // Column headers
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "İngilizce",
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
                Text(
                  "Türkçe",
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ],
            ),
          ),

          // Word list rows (from provider)
          Expanded(
            child: SingleChildScrollView(
                child: Column(
              children: addList.wordListField,
            )),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.lg, horizontal: AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              border: Border(
                top: BorderSide(color: AppColors.borderDark, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton(
                  onTap: addList.addRow,
                  icon: AppIcons.plus,
                  color: AppColors.warning,
                  label: "Ekle",
                ),
                _actionButton(
                  onTap: addList.save,
                  icon: AppIcons.floppyDisk,
                  color: AppColors.success,
                  label: "Kaydet",
                ),
                _actionButton(
                  onTap: addList.deleteRow,
                  icon: AppIcons.minus,
                  color: AppColors.error,
                  label: "Sil",
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _actionButton({
    required VoidCallback onTap,
    required String icon,
    required Color color,
    required String label,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusMd,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
            ),
            child: Center(
              child: AppIcons.svg(icon, size: 22, color: color),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
