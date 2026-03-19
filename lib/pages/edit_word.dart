import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../core/app_icons.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/theme/app_spacing.dart';
import '../global_widget/app_bar.dart';
import '../global_widget/text_filed.dart';
import '../provider/edit_word.dart';

final editList = ChangeNotifierProvider((ref) => EditListWord());

class EditWordPage extends ConsumerStatefulWidget {
  final int? listID;
  final String? listName;
  const EditWordPage(this.listID, this.listName, {Key? key}) : super(key: key);

  @override
  ConsumerState<EditWordPage> createState() =>
      _EditWordPageState(listID: listID, listName: listName);
}

class _EditWordPageState extends ConsumerState<EditWordPage> {
  int? listID;
  String? listName;
  _EditWordPageState({@required this.listID, @required this.listName});

  @override
  void initState() {
    super.initState();
    ref.read<EditListWord>(editList).getWordByList(listID);
  }

  @override
  Widget build(BuildContext context) {
    final editListProvider = ref.watch<EditListWord>(editList);
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: appbar(context,
          left: AppIcons.svg(AppIcons.arrowLeft,
              size: 22, color: AppColors.textPrimaryDark),
          center: Text(
            listName!,
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.textPrimaryDark,
            ),
          ),
          leftWidgetOnClik: () =>
              {Navigator.pop(context), editListProvider.close()}),
      body: Column(
        children: [
          // Action bar
          Container(
            height: 64,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: editListProvider.editController == false
                ? Row(children: [
                    _actionButton(
                      onTap: () {
                        editListProvider.editchange();
                      },
                      icon: AppIcons.pen,
                      iconColor: AppColors.warning,
                    ),
                  ])
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Row(children: [
                          _actionButton(
                            onTap: null,
                            icon: AppIcons.pen,
                            iconColor: AppColors.textTertiaryDark,
                            bgColor: AppColors.cardDarkElevated,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _actionButton(
                            onTap: () {
                              editListProvider.editchange();
                              for (int i = 0;
                                  i <
                                      editListProvider
                                          .selectIndexList.length;
                                  i++) {
                                editListProvider.selectIndexList[i] =
                                    false;
                              }
                              editListProvider.selectIndexList;
                            },
                            icon: AppIcons.xmark,
                            iconColor: AppColors.textSecondaryDark,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _actionButton(
                            onTap: () {
                              editListProvider.addRow(listID);
                            },
                            icon: AppIcons.circlePlus,
                            iconColor: AppColors.success,
                          ),
                        ]),
                        _actionButton(
                          onTap: () {
                            editListProvider.save(listID);
                          },
                          icon: AppIcons.floppyDisk,
                          iconColor: AppColors.success,
                        ),
                      ]),
          ),

          // Edit actions bar (when in edit mode)
          if (editListProvider.editController == true)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                border: Border(
                  bottom: BorderSide(color: AppColors.borderDark, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Seçilen Kelimeleri...",
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                  Row(
                    children: [
                      _editActionChip(
                        text: "Öğren",
                        color: AppColors.success,
                        onTap: editListProvider.learn,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _editActionChip(
                        text: "Unut",
                        color: AppColors.warning,
                        onTap: editListProvider.unlearn,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _editActionChip(
                        text: "Sil",
                        color: AppColors.error,
                        onTap: editListProvider.delete,
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Column headers
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl, vertical: AppSpacing.md),
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

          // Word list
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                itemBuilder: (context, index) {
                  return list(index,
                      wordTr: editListProvider.wordlist[index].word_tr,
                      wordEng: editListProvider.wordlist[index].word_eng,
                      learn: editListProvider.wordlist[index].status);
                },
                itemCount: editListProvider.wordlist.length),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    VoidCallback? onTap,
    required String icon,
    required Color iconColor,
    Color? bgColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusSm,
      child: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor ?? AppColors.cardDark,
          borderRadius: AppSpacing.borderRadiusSm,
          border: Border.all(color: AppColors.borderDark, width: 1),
        ),
        child: AppIcons.svg(icon, size: 20, color: iconColor),
      ),
    );
  }

  Widget _editActionChip({
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusSm,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.xs + 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: AppSpacing.borderRadiusSm,
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Text(
          text,
          style: AppTypography.labelMedium.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget list(
    int index, {
    @required String? wordTr,
    @required String? wordEng,
    @required bool? learn,
  }) {
    final editListProvider = ref.watch<EditListWord>(editList);
    editListProvider.wordTextEditingList[2 * index + 1].text = wordTr!;
    editListProvider.wordTextEditingList[2 * index].text = wordEng!;

    final Color statusColor = learn! ? AppColors.success : AppColors.primary;

    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppSpacing.borderRadiusSm,
        border: Border(
          left: BorderSide(color: statusColor, width: 3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
              child: textFieldBuilder(
                  borderColor: statusColor,
                  editting: editListProvider.editController,
                  padding: const EdgeInsets.only(left: 4),
                  textEditingController:
                      editListProvider.wordTextEditingList[2 * index])),
          Expanded(
              child: textFieldBuilder(
                  borderColor: statusColor,
                  editting: editListProvider.editController,
                  padding: const EdgeInsets.only(right: 4),
                  textEditingController:
                      editListProvider.wordTextEditingList[2 * index + 1])),
          editListProvider.editController
              ? Container(
                  padding: const EdgeInsets.only(top: 10),
                  margin: const EdgeInsets.only(right: 10),
                  width: 20,
                  height: 30,
                  child: Checkbox(
                    side: BorderSide(
                        color: AppColors.textTertiaryDark, width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    checkColor: Colors.white,
                    activeColor: AppColors.primary,
                    value: editListProvider.selectIndexList[index],
                    onChanged: (bool? value) {
                      editListProvider.selectIndexEdit(index);
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

}
