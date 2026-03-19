import 'package:english/global_widget/alert_dialog.dart';
import 'package:english/global_widget/app_bar.dart';
import 'package:english/pages/addlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../core/app_icons.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/theme/app_spacing.dart';
import '../db/db/db.dart';
import '../global_widget/toast_message.dart';
import 'edit_word.dart';

final getListWord = ChangeNotifierProvider((ref) => ListWord());

final editProvider = ChangeNotifierProvider((ref) => EditController());

class ListPage extends ConsumerStatefulWidget {
  final bool isTab;
  const ListPage({super.key, this.isTab = false});

  @override
  ConsumerState<ListPage> createState() => _ListPageState();
}

class _ListPageState extends ConsumerState<ListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(getListWord).getLists());
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final editController = ref.watch<EditController>(editProvider);
    final wordList = ref.watch<ListWord>(getListWord);
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: appbar(context,
          left: widget.isTab
              ? const SizedBox(width: 22)
              : AppIcons.svg(AppIcons.arrowLeft,
                  size: 22, color: AppColors.textPrimaryDark),
          center: Text(
            "Listelerim",
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.textPrimaryDark,
            ),
          ),
          right: const SizedBox(width: 24),
          leftWidgetOnClik: () => widget.isTab ? null : Navigator.pop(context)),
      body: Column(
        children: [
          // Action bar
          Container(
            height: 64,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: !editController.value
                ? Row(children: [
                    _actionButton(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const AddList())));
                      },
                      icon: AppIcons.circlePlus,
                      iconColor: AppColors.success,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _actionButton(
                      onTap: () {
                        editController.editchange();
                      },
                      icon: AppIcons.pen,
                      iconColor: AppColors.warning,
                    ),
                  ])
                : Row(children: [
                    _actionButton(
                      onTap: () {},
                      icon: AppIcons.circlePlus,
                      iconColor: AppColors.success,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _actionButton(
                      onTap: null,
                      icon: AppIcons.pen,
                      iconColor: AppColors.textTertiaryDark,
                      bgColor: AppColors.cardDarkElevated,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _actionButton(
                      onTap: () {
                        editController.editchange();
                      },
                      icon: AppIcons.xmark,
                      iconColor: AppColors.textSecondaryDark,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _actionButton(
                      onTap: () {
                        alertDialog(context, () => Navigator.pop(context), () {
                          wordList.delete();
                          editController.editchange();
                          Navigator.pop(context);
                        }, "Dikkat!", "Seçili listeler silinecek");
                      },
                      icon: AppIcons.trash,
                      iconColor: AppColors.error,
                    ),
                  ]),
          ),

          // List
          Expanded(
            child: wordList._lists.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppIcons.svg(AppIcons.book,
                            size: 48, color: AppColors.textTertiaryDark),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          "Henüz liste yok",
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.textTertiaryDark,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(
                        top: AppSpacing.sm, bottom: AppSpacing.xxl),
                    itemBuilder: (context, index) {
                      return listItem(
                          wordList._lists[index]['list_id'] as int, index,
                          listname:
                              wordList._lists[index]['name'].toString(),
                          sumWords:
                              wordList._lists[index]['sum_word'].toString(),
                          sumUnloearned: wordList._lists[index]
                                  ['sum_unlearned']
                              .toString());
                    },
                    itemCount: wordList._lists.length,
                  ),
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

  InkWell listItem(int id, int index,
      {@required String? listname,
      @required String? sumWords,
      @required String? sumUnloearned}) {
    final editController = ref.watch<EditController>(editProvider);
    final wordList = ref.watch<ListWord>(getListWord);

    final int total = int.tryParse(sumWords ?? '0') ?? 0;
    final int unlearned = int.tryParse(sumUnloearned ?? '0') ?? 0;
    final int learned = total - unlearned;
    final double progress = total > 0 ? (learned / total).clamp(0.0, 1.0) : 0.0;

    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EditWordPage(id, listname)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.xs + 2),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(color: AppColors.borderDark, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    listname!,
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.textPrimaryDark,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                editController.value
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          side: BorderSide(
                              color: AppColors.textTertiaryDark, width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          checkColor: Colors.white,
                          activeColor: AppColors.primary,
                          value: wordList.deleteIndexList[index],
                          onChanged: (bool? value) {
                            wordList.deleteIndexList[index] = value!;
                            bool deleteProcessController = false;
                            for (var element in wordList.deleteIndexList) {
                              if (element == true) {
                                deleteProcessController = true;
                              }
                            }
                            if (!deleteProcessController) {
                              editController._editCont = false;
                            }
                          },
                        ),
                      )
                    : AppIcons.svg(AppIcons.chevronRight,
                        size: 18, color: AppColors.textTertiaryDark),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Progress bar
            ClipRRect(
              borderRadius: AppSpacing.borderRadiusSm,
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: AppColors.borderDark,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            // Stats row
            Row(
              children: [
                AppIcons.svg(AppIcons.grip,
                    size: 13, color: AppColors.textTertiaryDark),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  "$sumWords kelime",
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                AppIcons.svg(AppIcons.circleCheck,
                    size: 13, color: AppColors.success),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  "$learned öğrenildi",
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

class EditController extends ChangeNotifier {
  bool _editCont = false;
  bool get value => _editCont;

  void editchange() {
    if (_editCont) {
      _editCont = false;
    } else {
      _editCont = true;
    }
    notifyListeners();
  }
}

class ListWord extends ChangeNotifier {
  List<Map<String, Object?>> _lists = [];
  List<bool> deleteIndexList = [];

  void getLists() async {
    _lists = await DB.instance.readListAll();
    deleteIndexList = List.filled(_lists.length, false);
    notifyListeners();
  }

  void delete() async {
    List<int> removeIndexList = [];

    for (int i = 0; i < _lists.length; i++) {
      if (deleteIndexList[i] == true) removeIndexList.add(i);
    }
    for (int i = removeIndexList.length - 1; i >= 0; i--) {
      DB.instance.deleteListsAndWordByList(
          _lists[removeIndexList[i]]['list_id'] as int);
      _lists.removeAt(removeIndexList[i]);
      deleteIndexList.removeAt(removeIndexList[i]);
    }
    for (int i = 0; i < deleteIndexList.length; i++) {
      deleteIndexList[i] = false;
    }

    toastMessage("Seçili listeler silindi.");
  }
}
