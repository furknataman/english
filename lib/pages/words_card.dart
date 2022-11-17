import 'package:english/global_variable.dart';
import 'package:english/global_widget/app_bar.dart';
import 'package:english/global_widget/toast_message.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../provider/admob.dart';
import '../provider/word_card.dart';

final wordCardChoiceProvider = ChangeNotifierProvider((ref) => WordCard());

class WordCardspage extends ConsumerStatefulWidget {
  const WordCardspage({Key? key}) : super(key: key);

  @override
  ConsumerState<WordCardspage> createState() => _WordCardspageState();
}

Container? adContainer;

class _WordCardspageState extends ConsumerState<WordCardspage> {
  @override
  void initState() {
    super.initState();
    ref.read<WordCard>(wordCardChoiceProvider).getLists();
    MobileAds.instance.initialize();
    myBanner.load();
    final AdWidget adWidget = AdWidget(ad: myBanner);
    adContainer = Container(
      alignment: Alignment.center,
      width: 320,
      height: 100,
      child: adWidget,
    );
  }

  CarouselController buttonCarouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    final wordCard = ref.watch<WordCard>(wordCardChoiceProvider);
    return Scaffold(
      backgroundColor: const Color(0xff3574C3),
      appBar: appbar(
        context,
        left: !wordCard.start
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
        center: !wordCard.start
            ? const Text(
                "Yeni Kart Destesi",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xffF3FBF8),
                  fontSize: 22,
                ),
              )
            : svgLogoIcon,
        leftWidgetOnClik: () =>
            !wordCard.start ? Navigator.pop(context) : wordCard.cancel(),
      ),
      body: Container(
          child: !wordCard.start
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
                                //learn
                                wordCard.changelearn();
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
                                    style: !wordCard.learn
                                        ? const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: Color(0xffBDBDBD))
                                        : const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: Color(0xff4F4F4F)),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                //learn
                                wordCard.changeunlearn();
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
                                    style: !wordCard.unlearn
                                        ? const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: Color(0xffBDBDBD))
                                        : const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
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
                                      wordCard.getSelectedWordOfLists(selectedListIdList);
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
                        )
                      ]),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: adContainer!,
                      )
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
                              //learn
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
                              (BuildContext context, itemIndex, int pageViewIndex) {
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
                                    Container(
                                      width: 385,
                                      height: 350,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            const BorderRadius.all(Radius.circular(20)),
                                        color:
                                            wordCard.cardColor[(wordCard.indexpage) % 4],
                                      ),
                                    ),
                                    Container(
                                      width: 385,
                                      height: 330,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            const BorderRadius.all(Radius.circular(20)),
                                        color: wordCard
                                            .cardColor[(wordCard.indexpage + 1) % 4],
                                      ),
                                    ),
                                    Positioned(
                                      child: Container(
                                        width: 385,
                                        height: 310,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              const BorderRadius.all(Radius.circular(20)),
                                          color: wordCard
                                              .cardColor[(wordCard.indexpage + 2) % 4],
                                        ),
                                      ),
                                    ),
                                    FlipCard(
                                      direction: FlipDirection.VERTICAL,
                                      onFlip: () {
                                        if (wordCard.changeLand[itemIndex] == true) {
                                          wordCard.changeLand[itemIndex] = false;
                                        } else {
                                          wordCard.changeLand[itemIndex] = true;
                                        }
                                      },
                                      front: Stack(children: [
                                        Container(
                                          width: 385,
                                          height: 290,
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(20)),
                                            color: wordCard
                                                .cardColor[(wordCard.indexpage + 3) % 4],
                                          ),
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(bottom: 16),
                                          padding: const EdgeInsets.only(
                                              left: 4, top: 15, right: 4),
                                          child: Text(
                                            word,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 28,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Positioned(
                                          left: 40,
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 45,
                                            height: 45,
                                            decoration: const BoxDecoration(
                                                color: Color(0xff002250),
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft: Radius.circular(10),
                                                    bottomRight: Radius.circular(10))),
                                            child: Text(
                                              "${itemIndex + 1}/${wordCard.words.length}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: Color(0xffF3FBF8),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 40,
                                          bottom: 15,
                                          child: Container(
                                              alignment: Alignment.center,
                                              width: 60,
                                              height: 60,
                                              decoration: const BoxDecoration(
                                                  color: Color(0xff002250),
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(10),
                                                      topRight: Radius.circular(10))),
                                              child: const Icon(
                                                Icons.remove_red_eye_outlined,
                                                size: 40,
                                                color: Colors.white,
                                              )),
                                        ),
                                      ]),
                                      back: Stack(children: [
                                        Container(
                                          width: 385,
                                          height: 290,
                                          decoration: const BoxDecoration(
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(20)),
                                            color: Color(0xff002250),
                                          ),
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(bottom: 16),
                                          padding: const EdgeInsets.only(
                                              left: 4, top: 15, right: 4),
                                          child: Text(
                                            word,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 28,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Positioned(
                                          left: 40,
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 45,
                                            height: 45,
                                            decoration: const BoxDecoration(
                                                color: Color(0xffF3FBF8),
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft: Radius.circular(10),
                                                    bottomRight: Radius.circular(10))),
                                            child: Text(
                                              "${itemIndex + 1}/${wordCard.words.length}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: Color(0xff002250),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 40,
                                          bottom: 15,
                                          child: Container(
                                              alignment: Alignment.center,
                                              width: 60,
                                              height: 60,
                                              decoration: const BoxDecoration(
                                                  color: Color(0xffF3FBF8),
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(10),
                                                      topRight: Radius.circular(10))),
                                              child: const FaIcon(
                                                FontAwesomeIcons.eyeSlash,
                                                size: 32,
                                                color: Colors.black,
                                              )),
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
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
                                  wordCard.changelearnType();
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
                                                wordCard.words[wordCard.indexpage].status,
                                            onChanged: (value) {
                                              wordCard.changelearnType();
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
                fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xff4F4F4F)),
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
}
