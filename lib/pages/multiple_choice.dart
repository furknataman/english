import 'package:english/global_variable.dart';
import 'package:english/global_widget/app_bar.dart';
import 'package:english/global_widget/toast_message.dart';
import 'package:english/provider/multiple_choice.dart';
import 'package:english/core/theme/app_colors.dart';
import 'package:english/core/theme/app_typography.dart';
import 'package:english/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../core/app_icons.dart';

final multipleChoiceProvider =
    ChangeNotifierProvider((ref) => MultipleChoice());

class MultipleChoicePage extends ConsumerStatefulWidget {
  const MultipleChoicePage({super.key});

  @override
  ConsumerState<MultipleChoicePage> createState() => _MultipleChoicePage();
}

class _MultipleChoicePage extends ConsumerState<MultipleChoicePage> {
  @override
  void initState() {
    super.initState();
    ref.read<MultipleChoice>(multipleChoiceProvider).getLists();
  }

  CarouselSliderController buttonCarouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final multiple = ref.watch<MultipleChoice>(multipleChoiceProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: appbar(
        context,
        left: multiple.start == false
            ? AppIcons.svg(AppIcons.arrowLeft,
                size: 22, color: AppColors.textPrimaryDark)
            : AppIcons.svg(AppIcons.circleXmark,
                size: 31, color: AppColors.textPrimaryDark),
        center: !multiple.start
            ? Text(
                "Çoktan Seçmeli",
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.textPrimaryDark,
                ),
              )
            : svgLogoIcon,
        right: multiple.start
            ? Container(
                alignment: Alignment.center,
                width: 80,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: AppSpacing.borderRadiusXl,
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "${multiple.correctCount}",
                      style: AppTypography.headlineSmall.copyWith(
                        color: AppColors.success,
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      width: 1.5,
                      height: 18,
                      color: AppColors.borderDark,
                    ),
                    Text(
                      "${multiple.wrongCount}",
                      style: AppTypography.headlineSmall.copyWith(
                        color: AppColors.error,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
        leftWidgetOnClik: () =>
            !multiple.start ? Navigator.pop(context) : multiple.cancel(),
      ),
      body: !multiple.start
          ? _buildSetupView(multiple)
          : _buildQuizView(multiple),
    );
  }

  // ---------------------------------------------------------------------------
  // SETUP STATE
  // ---------------------------------------------------------------------------
  Widget _buildSetupView(
      MultipleChoice multiple) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: AppSpacing.lg, top: AppSpacing.xxl),
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radiusXl),
          topRight: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "İçerik",
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      _filterChip(
                        label: "Öğrendiklerim",
                        active: multiple.learn,
                        onTap: () => multiple.changelearn(),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _filterChip(
                        label: "Öğrenmediklerim",
                        active: multiple.unlearn,
                        onTap: () => multiple.changeunlearn(),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    "Kaynak Listeler",
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    height: 210,
                    child: Scrollbar(
                      thickness: 4,
                      radius:
                          const Radius.circular(AppSpacing.radiusFull),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return _checkBox(
                            index: index,
                            text: lists[index]['name'].toString(),
                          );
                        },
                        itemCount: lists.length,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    "Deste Ayarları",
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: AppSpacing.md, right: AppSpacing.lg),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Listeyi Karıştır",
                          style: AppTypography.titleLarge.copyWith(
                            color: AppColors.textSecondaryDark,
                          ),
                        ),
                        FlutterSwitch(
                          activeTextColor: Colors.white,
                          inactiveTextColor: AppColors.textSecondaryDark,
                          width: 88.0,
                          height: 34.0,
                          valueFontSize: 14.0,
                          activeColor: AppColors.primary,
                          inactiveSwitchBorder:
                              Border.all(color: AppColors.borderDark),
                          activeText: "Açık",
                          inactiveText: "Kapalı",
                          toggleSize: 28.0,
                          inactiveColor: AppColors.cardDark,
                          inactiveToggleColor: AppColors.textTertiaryDark,
                          value: listMixed,
                          borderRadius: 18.0,
                          padding: 3.0,
                          showOnOff: true,
                          onToggle: (val) {
                            setState(() {
                              listMixed = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCreateButton(
                        onTap: () {
                          if (multiple.learn == false &&
                              multiple.unlearn == false) {
                            toastMessage("Lütfen, içerik seçiniz");
                          } else {
                            List<int> selectedIndexNoOfList = [];
                            for (int i = 0;
                                i < selectedListIndex.length;
                                i++) {
                              if (selectedListIndex[i] == true) {
                                selectedIndexNoOfList.add(i);
                              }
                            }
                            List<int> selectedListIdList = [];
                            for (int i = 0;
                                i < selectedIndexNoOfList.length;
                                i++) {
                              selectedListIdList.add(
                                  lists[selectedIndexNoOfList[i]]['list_id']
                                      as int);
                            }
                            if (selectedListIdList.isNotEmpty) {
                              multiple
                                  .getSelectedWordOfLists(selectedListIdList);
                            } else {
                              toastMessage("Lütfen, liste seçiniz");
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // QUIZ STATE
  // ---------------------------------------------------------------------------
  Widget _buildQuizView(MultipleChoice multiple) {
    return Padding(
      padding: const EdgeInsets.only(
          top: AppSpacing.xxl,
          bottom: AppSpacing.xxl,
          left: AppSpacing.lg,
          right: AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CarouselSlider.builder(
            carouselController: buttonCarouselController,
            options: CarouselOptions(
              onPageChanged: (index, reason) {
                multiple.changeIndex(index);
                multiple.correct = false;
                multiple.clicked = false;
              },
              scrollPhysics: const NeverScrollableScrollPhysics(),
              enlargeCenterPage: true,
              height: 480,
              viewportFraction: 1,
              enableInfiniteScroll: true,
            ),
            itemCount: multiple.words.length,
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) {
              return Column(
                children: [
                  // Question card
                  Stack(
                    children: [
                      Container(
                        width: 385,
                        height: 290,
                        decoration: BoxDecoration(
                          borderRadius: AppSpacing.borderRadiusXl,
                          gradient: !multiple.clicked
                              ? AppColors.cardGradient
                              : AppColors.primaryGradient,
                          border: Border.all(
                            color: !multiple.clicked
                                ? AppColors.primary.withValues(alpha: 0.3)
                                : AppColors.primaryLight.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.only(
                            left: AppSpacing.xs,
                            top: AppSpacing.lg,
                            right: AppSpacing.xs),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            !multiple.clicked
                                ? Text(
                                    chooeseLang == Lang.eng
                                        ? multiple
                                            .words[itemIndex].word_eng!
                                        : multiple
                                            .words[itemIndex].word_tr!,
                                    style:
                                        AppTypography.displayMedium.copyWith(
                                      color: AppColors.textPrimaryDark,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    chooeseLang != Lang.eng
                                        ? multiple
                                            .words[itemIndex].word_eng!
                                        : multiple
                                            .words[itemIndex].word_tr!,
                                    style:
                                        AppTypography.displayMedium.copyWith(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                          ],
                        ),
                      ),
                      // Result icon
                      if (multiple.clicked)
                        Positioned(
                          right: 30,
                          top: 30,
                          child: multiple.correct
                              ? AppIcons.svg(AppIcons.circleCheck,
                                  size: 56, color: AppColors.successLight)
                              : AppIcons.svg(AppIcons.xmark,
                                  size: 56, color: AppColors.errorLight),
                        ),
                      // Index badge
                      Positioned(
                        left: 30,
                        child: Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 45,
                          decoration: BoxDecoration(
                            color: multiple.clicked
                                ? Colors.white
                                : AppColors.primary,
                            borderRadius: const BorderRadius.only(
                              bottomLeft:
                                  Radius.circular(AppSpacing.radiusSm),
                              bottomRight:
                                  Radius.circular(AppSpacing.radiusSm),
                            ),
                          ),
                          child: Text(
                            "${itemIndex + 1}/${multiple.words.length}",
                            style: AppTypography.titleMedium.copyWith(
                              color: multiple.clicked
                                  ? AppColors.primary
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Options
                  _customRadioButtonList(
                    itemIndex,
                    multiple.optionsList[itemIndex],
                    multiple.correctAnswers[itemIndex],
                  ),
                ],
              );
            },
          ),
          // Navigation
          _buildNavigationControls(multiple),
        ],
      ),
    );
  }

  Widget _buildNavigationControls(MultipleChoice multiple) {
    return SizedBox(
      height: 86,
      width: 390,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            padding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            width: 380,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: AppSpacing.borderRadiusXl,
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _navButton(
                  label: "Önceki",
                  onTap: () => buttonCarouselController.previousPage(
                      duration: const Duration(milliseconds: 1),
                      curve: Curves.easeInExpo),
                ),
                _navButton(
                  label: "Sonraki",
                  onTap: () => buttonCarouselController.nextPage(
                      duration: const Duration(milliseconds: 1),
                      curve: Curves.easeInBack),
                ),
              ],
            ),
          ),
          // Learned checkbox
          Positioned(
            bottom: 50,
            child: InkWell(
              onTap: () {
                multiple.changelearnType();
              },
              borderRadius: AppSpacing.borderRadiusSm,
              child: Container(
                alignment: Alignment.centerLeft,
                width: 130,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: AppSpacing.borderRadiusSm,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 17,
                      height: 17,
                      child: Checkbox(
                        side: WidgetStateBorderSide.resolveWith((states) {
                          return const BorderSide(color: Colors.white);
                        }),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        checkColor: AppColors.success,
                        activeColor: Colors.white,
                        value: multiple.words[multiple.indexpage].status,
                        onChanged: (value) {
                          multiple.changelearnType();
                        },
                      ),
                    ),
                    Text(
                      "Öğrendim",
                      style: AppTypography.titleMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SHARED WIDGETS
  // ---------------------------------------------------------------------------
  Widget _filterChip({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusSm,
      child: Container(
        height: 38,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.cardDark,
          borderRadius: AppSpacing.borderRadiusSm,
          border: Border.all(
            color: active ? AppColors.primary : AppColors.borderDark,
            width: active ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.titleMedium.copyWith(
            color: active ? AppColors.primary : AppColors.textTertiaryDark,
          ),
        ),
      ),
    );
  }

  Widget _buildCreateButton({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusMd,
      child: Container(
        width: 140,
        height: 44,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: AppSpacing.borderRadiusMd,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          "Oluştur",
          style: AppTypography.titleMedium.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _navButton({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusXl,
      child: Container(
        alignment: Alignment.center,
        height: 36,
        width: 100,
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: AppSpacing.borderRadiusXl,
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Text(
          label,
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
      ),
    );
  }

  Container _checkBox({int index = 0, String? text}) {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.xs, right: AppSpacing.xl),
      width: 363,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppSpacing.borderRadiusSm,
        border: Border.all(
          color: selectedListIndex[index]
              ? AppColors.primary.withValues(alpha: 0.5)
              : AppColors.borderDark,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(bottom: 3),
        horizontalTitleGap: 1,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(
            text!,
            style: AppTypography.titleLarge.copyWith(
              color: selectedListIndex[index]
                  ? AppColors.textPrimaryDark
                  : AppColors.textSecondaryDark,
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Checkbox(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            checkColor: Colors.white,
            activeColor: AppColors.primary,
            side: BorderSide(
              color: selectedListIndex[index]
                  ? AppColors.primary
                  : AppColors.textTertiaryDark,
            ),
            value: selectedListIndex[index],
            onChanged: (bool? value) {
              setState(() {
                selectedListIndex[index] = value!;
              });
            },
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // QUIZ OPTION WIDGETS
  // ---------------------------------------------------------------------------
  Container _customRadioButton(
      int index, List<String> options, int order) {
    final multiple = ref.watch<MultipleChoice>(multipleChoiceProvider);

    Color borderColor = AppColors.borderDark;
    double borderWidth = 1.0;
    Color bgColor = AppColors.cardDark;

    if (multiple.clickControlList[index][order] != false) {
      if (multiple.correct != false) {
        borderColor = AppColors.success;
        borderWidth = 2.5;
        bgColor = AppColors.success.withValues(alpha: 0.1);
      } else {
        borderColor = AppColors.error;
        borderWidth = 2.5;
        bgColor = AppColors.error.withValues(alpha: 0.1);
      }
    }

    return Container(
      alignment: Alignment.center,
      width: 170,
      height: 44,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      margin: const EdgeInsets.all(4),
      child: Text(
        options[order],
        style: AppTypography.titleMedium.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Column _customRadioButtonList(
      int index, List<String> options, String correctAnswers) {
    final multiple = ref.watch<MultipleChoice>(multipleChoiceProvider);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                multiple.checher(index, 0, options, correctAnswers);
              },
              borderRadius: AppSpacing.borderRadiusMd,
              child: _customRadioButton(index, options, 0),
            ),
            InkWell(
              onTap: () {
                multiple.checher(index, 1, options, correctAnswers);
              },
              borderRadius: AppSpacing.borderRadiusMd,
              child: _customRadioButton(index, options, 1),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                multiple.checher(index, 2, options, correctAnswers);
              },
              borderRadius: AppSpacing.borderRadiusMd,
              child: _customRadioButton(index, options, 2),
            ),
            InkWell(
              onTap: () {
                multiple.checher(index, 3, options, correctAnswers);
              },
              borderRadius: AppSpacing.borderRadiusMd,
              child: _customRadioButton(index, options, 3),
            ),
          ],
        ),
      ],
    );
  }
}
