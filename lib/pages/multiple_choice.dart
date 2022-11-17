import 'package:english/global_variable.dart';
import 'package:english/global_widget/app_bar.dart';
import 'package:english/global_widget/toast_message.dart';
import 'package:english/provider/multiple_choice.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../admob/admob_multiple_page.dart';

final multipleChoiceProvider = ChangeNotifierProvider((ref) => MultipleChoice());

class MultipleChoicePage extends ConsumerStatefulWidget {
  const MultipleChoicePage({Key? key}) : super(key: key);

  @override
  ConsumerState<MultipleChoicePage> createState() => _MultipleChoicePage();
}


class _MultipleChoicePage extends ConsumerState<MultipleChoicePage> {
  @override
  void initState() {
    super.initState();
    ref.read<MultipleChoice>(multipleChoiceProvider).getLists();
  }

  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final multiple = ref.watch<MultipleChoice>(multipleChoiceProvider);
    AsyncValue<Container> adMob = ref.watch(configAdmob);
    return Scaffold(
      backgroundColor: const Color(0xff3574C3),
      appBar: appbar(
        context,
        left: multiple.start == false
            ? const Icon(
                Icons.arrow_back_ios,
                color: Color(0xffF3FBF8),
                size: 22,
              )
            : const Icon(
                Icons.highlight_off_outlined,
                color: Color(0xffF3FBF8),
                size: 31,
              ),
        center: !multiple.start
            ? const Text(
                "Çoktan Seçmeli",
                style: TextStyle(
                  color: Color(0xffF3FBF8),
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              )
            : svgLogoIcon,
        right: multiple.start
            ? Container(
                alignment: Alignment.center,
                width: 73,
                height: 28,
                decoration: const BoxDecoration(
                    color: Color(0xffF3FBF8),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "${multiple.correctCount}",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 79, 177, 120)),
                    ),
                    const VerticalDivider(
                      color: Color(0xffBDBDBD),
                      thickness: 2,
                      width: 8,
                    ),
                    Text(
                      "${multiple.wrongCount}",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffEB5757)),
                    ),
                  ],
                ),
              )
            : Container(),
        leftWidgetOnClik: () =>
            !multiple.start ? Navigator.pop(context) : multiple.cancel(),
      ),
      body: Container(
          child: !multiple.start
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    left: 15,
                    top: 40,
                  ),
                  decoration: const BoxDecoration(
                      color: Color(0xffF3FBF8),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text(
                          "İçerik",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xff333333),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                multiple.changelearn();
                              },
                              child: Container(
                                width: 134,
                                height: 36,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(top: 9, right: 9),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    "Öğrendiklerim",
                                    style: !multiple.learn
                                        ? const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xffBDBDBD))
                                        : const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff4F4F4F)),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                multiple.changeunlearn();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 144,
                                height: 36,
                                margin: const EdgeInsets.only(top: 9),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    "Öğrenmediklerim",
                                    style: !multiple.unlearn
                                        ? const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xffBDBDBD))
                                        : const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff4F4F4F)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text("Kaynak Listeler",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Color(0xff333333))),
                        SizedBox(
                          height: 210,
                          child: Scrollbar(
                            thickness: 5,
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return checkBox(
                                    index: index, text: lists[index]['name'].toString());
                              },
                              itemCount: lists.length,
                            ),
                          ),
                        ),
                        const Text(
                          "Deste Ayarları",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xff333333),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Listeyi Karıştır",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xff4F4F4F)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: FlutterSwitch(
                                  activeTextColor: Colors.white,
                                  inactiveTextColor: const Color(0xff828282),
                                  width: 88.0,
                                  height: 34.0,
                                  valueFontSize: 14.0,
                                  activeColor: const Color(0xff3574C3),
                                  inactiveSwitchBorder:
                                      Border.all(color: const Color(0xffBDBDBD)),
                                  activeText: "Açık",
                                  inactiveText: "Kapalı",
                                  toggleSize: 28.0,
                                  inactiveColor: const Color(0xffFFFFFF),
                                  inactiveToggleColor: const Color(0xffBDBDBD),
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
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 36,
                              decoration: const BoxDecoration(
                                  color: Color(0xff3574C3),
                                  borderRadius: BorderRadius.all(Radius.circular(20))),
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(right: 20),
                              child: InkWell(
                                onTap: () {
                                  if (multiple.learn == false &&
                                      multiple.unlearn == false) {
                                    toastMessage("Lütfen, içerik seçiniz");
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
                                      multiple.getSelectedWordOfLists(selectedListIdList);
                                    } else {
                                      toastMessage("Lütfen, liste seçiniz");
                                    }
                                  }
                                },
                                child: const Text(
                                  "Oluştur",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xffF3FBF8),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: adMob.when(
                            loading: () => const CircularProgressIndicator(),
                            error: (err, stack) => Text('Error: $err'),
                            data: (adMob) {
                              return adMob;
                            },
                          ))
                    ],
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.only(top: 24.0, bottom: 24, left: 15, right: 15),
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
                                Stack(
                                  children: [
                                    Container(
                                      width: 385,
                                      height: 290,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            const BorderRadius.all(Radius.circular(20)),
                                        color: !multiple.clicked
                                            ? const Color(0xffF3FBF8)
                                            : const Color(0xff002250),
                                      ),
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(bottom: 16),
                                      padding: const EdgeInsets.only(
                                          left: 4, top: 15, right: 4),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          !multiple.clicked
                                              ? Text(
                                                  chooeseLang == Lang.eng
                                                      ? multiple.words[itemIndex].word_eng!
                                                      : multiple.words[itemIndex].word_tr!,
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 28,
                                                      color: Colors.black),
                                                )
                                              : Text(
                                                  chooeseLang != Lang.eng
                                                      ? multiple.words[itemIndex].word_eng!
                                                      : multiple.words[itemIndex].word_tr!,
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 28,
                                                      color: Colors.white),
                                                ),
                                        ],
                                      ),
                                    ),
                                    if (multiple.clicked)
                                      Positioned(
                                          right: 30,
                                          top: 30,
                                          child: multiple.correct
                                              ? const FaIcon(
                                                  FontAwesomeIcons.circleCheck,
                                                  color:
                                                      Color.fromARGB(255, 102, 210, 147),
                                                  size: 60,
                                                )
                                              : const Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                  size: 60,
                                                )),
                                    Positioned(
                                        left: 30,
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 45,
                                          height: 45,
                                          decoration: BoxDecoration(
                                              color: multiple.clicked
                                                  ? const Color(0xffF3FBF8)
                                                  : const Color(0xff002250),
                                              borderRadius: const BorderRadius.only(
                                                  bottomLeft: Radius.circular(10),
                                                  bottomRight: Radius.circular(10))),
                                          child: Text(
                                            "${itemIndex + 1}/${multiple.words.length}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: multiple.clicked == false
                                                    ? const Color(0xffF3FBF8)
                                                    : const Color(0xff002250)),
                                          ),
                                        )),
                                  ],
                                ),
                                Container(
                                  child: customRadioButtonList(
                                      itemIndex,
                                      multiple.optionsList[itemIndex],
                                      multiple.correctAnswers[itemIndex]),
                                )
                              ],
                            );
                          }),
                      SizedBox(
                        height: 86,
                        width: 390,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              width: 380,
                              height: 50,
                              decoration: const BoxDecoration(
                                  color: Color(0xffF3FBF8),
                                  borderRadius: BorderRadius.all(Radius.circular(20))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () => buttonCarouselController.previousPage(
                                        duration: const Duration(milliseconds: 1),
                                        curve: Curves.easeInExpo),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 36,
                                      width: 100,
                                      decoration: const BoxDecoration(
                                          color: Color(0xffE0E0E0),
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(20))),
                                      child: const Text(
                                        "Önceki",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff4F4F4F)),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => buttonCarouselController.nextPage(
                                        duration: const Duration(milliseconds: 1),
                                        curve: Curves.easeInBack),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 36,
                                      width: 100,
                                      decoration: const BoxDecoration(
                                          color: Color(0xffE0E0E0),
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(20))),
                                      child: const Text(
                                        "Sonraki",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff4F4F4F)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 50,
                              child: InkWell(
                                onTap: () {
                                  multiple.changelearnType();
                                },
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: 120,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                        color: Color(0xff6FCF97),
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10))),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: 17,
                                          height: 17,
                                          child: Checkbox(
                                            side: MaterialStateBorderSide.resolveWith(
                                                (states) {
                                              if (states.contains(MaterialState.pressed)) {
                                                return const BorderSide(
                                                    color: Colors.white);
                                              } else {
                                                return const BorderSide(
                                                    color: Colors.white);
                                              }
                                            }),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0))),
                                            checkColor: Colors.black,
                                            activeColor: const Color(0xff6FCF97),
                                            hoverColor: Colors.blueAccent,
                                            value:
                                                multiple.words[multiple.indexpage].status,
                                            onChanged: (value) {
                                              multiple.changelearnType();
                                            },
                                          ),
                                        ),
                                        const Text(
                                          "Öğrendim",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }

  Container checkBox({int index = 0, String? text}) {
    return Container(
      margin: const EdgeInsets.only(top: 5, right: 20),
      width: 363,
      height: 42,
      decoration: const BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
      child: ListTile(
        contentPadding: const EdgeInsets.only(bottom: 3),
        horizontalTitleGap: 1,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(
            text!,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff4F4F4F)),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Checkbox(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            checkColor: Colors.white,
            activeColor: const Color(0xff3574C3),
            hoverColor: Colors.blueAccent,
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

  Container customRadioButton(int index, List<String> options, int order) {
    final multiple = ref.watch<MultipleChoice>(multipleChoiceProvider);
    return Container(
      alignment: Alignment.center,
      width: 170,
      height: 40,
      decoration: BoxDecoration(
          color: const Color(0xffF3FBF8),
          border: multiple.clickControlList[index][order] != false
              ? multiple.correct != false
                  ? Border.all(
                      color: const Color(0xff6FCF97),
                      width: 4,
                    )
                  : Border.all(
                      color: Colors.red,
                      width: 4,
                    )
              : Border.all(
                  color: const Color(0xffF3FBF8),
                  width: 2,
                ),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      margin: const EdgeInsets.all(4),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(
          width: 10,
        ),
        Text(
          options[order],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        )
      ]),
    );
  }

  Column customRadioButtonList(int index, List<String> options, String correctAnswers) {
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
              child: customRadioButton(index, options, 0),
            ),
            InkWell(
              onTap: () {
                multiple.checher(index, 1, options, correctAnswers);
              },
              child: customRadioButton(index, options, 1),
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
              child: customRadioButton(index, options, 2),
            ),
            InkWell(
              onTap: () {
                multiple.checher(index, 3, options, correctAnswers);
              },
              child: customRadioButton(index, options, 3),
            ),
          ],
        )
      ],
    );
  }
}
