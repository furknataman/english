import 'package:english/global_variable.dart';
import 'package:english/global_widget/app_bar.dart';
import 'package:english/global_widget/toast_message.dart';
import 'package:english/core/theme/app_colors.dart';
import 'package:english/core/theme/app_typography.dart';
import 'package:english/core/theme/app_spacing.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../core/app_icons.dart';
import '../provider/word_card.dart';

final wordCardChoiceProvider = ChangeNotifierProvider((ref) => WordCard());

class WordCardspage extends ConsumerStatefulWidget {
  const WordCardspage({super.key});

  @override
  ConsumerState<WordCardspage> createState() => _WordCardspageState();
}

class _WordCardspageState extends ConsumerState<WordCardspage> {
  @override
  void initState() {
    super.initState();
    ref.read<WordCard>(wordCardChoiceProvider).getLists();
  }

  CarouselSliderController buttonCarouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final wordCard = ref.watch<WordCard>(wordCardChoiceProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: appbar(
        context,
        left: !wordCard.start
            ? AppIcons.svg(AppIcons.arrowLeft,
                size: 22, color: AppColors.textPrimaryDark)
            : AppIcons.svg(AppIcons.circleXmark,
                size: 31, color: AppColors.textPrimaryDark),
        center: !wordCard.start
            ? Text(
                "Yeni Kart Destesi",
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.textPrimaryDark,
                ),
              )
            : svgLogoIcon,
        leftWidgetOnClik: () =>
            !wordCard.start ? Navigator.pop(context) : wordCard.cancel(),
      ),
      body: !wordCard.start ? _buildSetupView(wordCard) : _buildStudyView(wordCard),
    );
  }

  // ---------------------------------------------------------------------------
  // SETUP STATE
  // ---------------------------------------------------------------------------
  Widget _buildSetupView(WordCard wordCard) {
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
                        active: wordCard.learn,
                        onTap: () => wordCard.changelearn(),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _filterChip(
                        label: "Öğrenmediklerim",
                        active: wordCard.unlearn,
                        onTap: () => wordCard.changeunlearn(),
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
                      radius: const Radius.circular(AppSpacing.radiusFull),
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
                    padding:
                        const EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.lg),
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
                          if (wordCard.learn == false &&
                              wordCard.unlearn == false) {
                            toastMessage("Lütfen İçerik Seçiniz");
                          } else {
                            List<int> selectedIndexNoOfList = [];
                            for (int i = 0; i < selectedListIndex.length; i++) {
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
                              wordCard
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
  // STUDY STATE
  // ---------------------------------------------------------------------------
  Widget _buildStudyView(WordCard wordCard) {
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
                wordCard.changeIndex(index);
              },
              scrollPhysics: const NeverScrollableScrollPhysics(),
              enlargeCenterPage: true,
              height: 500,
              viewportFraction: 1,
              enableInfiniteScroll: true,
            ),
            itemCount: wordCard.words.length,
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) {
              String word = "";
              if (chooeseLang == Lang.tr) {
                word = wordCard.changeLand[itemIndex]
                    ? wordCard.words[itemIndex].word_tr!
                    : wordCard.words[itemIndex].word_eng!;
              } else {
                word = wordCard.changeLand[itemIndex]
                    ? wordCard.words[itemIndex].word_eng!
                    : wordCard.words[itemIndex].word_tr!;
              }
              return Column(
                children: [
                  Stack(
                    children: [
                      // Background stacked cards for depth effect
                      Container(
                        width: 385,
                        height: 350,
                        decoration: BoxDecoration(
                          borderRadius: AppSpacing.borderRadiusXl,
                          color: AppColors.cardDark.withValues(alpha: 0.4),
                          border: Border.all(
                              color: AppColors.borderDark.withValues(alpha: 0.3)),
                        ),
                      ),
                      Container(
                        width: 385,
                        height: 330,
                        decoration: BoxDecoration(
                          borderRadius: AppSpacing.borderRadiusXl,
                          color: AppColors.cardDark.withValues(alpha: 0.6),
                          border: Border.all(
                              color: AppColors.borderDark.withValues(alpha: 0.4)),
                        ),
                      ),
                      Container(
                        width: 385,
                        height: 310,
                        decoration: BoxDecoration(
                          borderRadius: AppSpacing.borderRadiusXl,
                          color: AppColors.cardDark.withValues(alpha: 0.8),
                          border: Border.all(
                              color: AppColors.borderDark.withValues(alpha: 0.5)),
                        ),
                      ),
                      // Flip card
                      FlipCard(
                        direction: FlipDirection.VERTICAL,
                        onFlip: () {
                          wordCard.changLand(itemIndex);
                        },
                        front: _buildCardFace(
                          word: word,
                          itemIndex: itemIndex,
                          totalCount: wordCard.words.length,
                          isFront: true,
                        ),
                        back: _buildCardFace(
                          word: word,
                          itemIndex: itemIndex,
                          totalCount: wordCard.words.length,
                          isFront: false,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          // Navigation controls
          _buildNavigationControls(wordCard),
        ],
      ),
    );
  }

  Widget _buildCardFace({
    required String word,
    required int itemIndex,
    required int totalCount,
    required bool isFront,
  }) {
    return Stack(
      children: [
        Container(
          width: 385,
          height: 290,
          decoration: BoxDecoration(
            borderRadius: AppSpacing.borderRadiusXl,
            gradient: isFront
                ? const LinearGradient(
                    colors: [AppColors.cardDarkElevated, AppColors.cardDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : AppColors.primaryGradient,
            border: Border.all(
              color: isFront
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
          padding:
              const EdgeInsets.only(left: AppSpacing.xs, top: AppSpacing.lg, right: AppSpacing.xs),
          child: Text(
            word,
            style: AppTypography.displayMedium.copyWith(
              color: AppColors.textPrimaryDark,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // Index badge
        Positioned(
          left: 40,
          child: Container(
            alignment: Alignment.center,
            width: 50,
            height: 45,
            decoration: BoxDecoration(
              color: isFront ? AppColors.primary : Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(AppSpacing.radiusSm),
                bottomRight: Radius.circular(AppSpacing.radiusSm),
              ),
            ),
            child: Text(
              "${itemIndex + 1}/$totalCount",
              style: AppTypography.titleMedium.copyWith(
                color: isFront ? Colors.white : AppColors.primary,
              ),
            ),
          ),
        ),
        // Eye icon
        Positioned(
          right: 40,
          bottom: 15,
          child: Container(
            alignment: Alignment.center,
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isFront
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : Colors.white.withValues(alpha: 0.15),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.radiusSm),
                topRight: Radius.circular(AppSpacing.radiusSm),
              ),
            ),
            child: AppIcons.svg(
              isFront ? AppIcons.eye : AppIcons.eyeSlash,
              size: isFront ? 36 : 30,
              color: isFront
                  ? AppColors.primary
                  : Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationControls(WordCard wordCard) {
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
                wordCard.changelearnType();
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
                        value: wordCard.words[wordCard.indexpage].status,
                        onChanged: (value) {
                          wordCard.changelearnType();
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
          color: active ? AppColors.primary.withValues(alpha: 0.15) : AppColors.cardDark,
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
}
