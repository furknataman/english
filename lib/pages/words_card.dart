import 'package:english/db/models/words.dart';
import 'package:english/global_variable.dart';
import 'package:english/global_widget/app_bar.dart';
import 'package:english/global_widget/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';

import '../db/db/db.dart';
import '../db/db/sharedPreferences.dart';

class WordCardspage extends StatefulWidget {
  const WordCardspage({Key? key}) : super(key: key);

  @override
  State<WordCardspage> createState() => _WordCardspageState();
}

class _WordCardspageState extends State<WordCardspage> {
  @override
  void initState() {
    super.initState();
    getLists();
  }

  void getLists() async {
    Object? value = await SP.read("selected_list");

    lists = await DB.instance.readListAll();
    selectedListIndex = [];

    for (int i = 0; i < lists.length; i++) {
      bool isThereSame = false;
      if (value != null) {
        for (var element in (value as List)) {
          if (element == lists[i]['list_id'].toString()) {
            isThereSame = true;
          }
        }
      }

      selectedListIndex.add(isThereSame);
    }

    setState(() {
      lists;
    });
  }

  List<Word> _words = [];
  bool start = false;
  List<bool> changeLand = [];
  bool learn = false;
  bool unlearn = false;

  void getSelectedWordOfLists(List<int> selectedListID) async {
    List<String> value = selectedListID.map((e) => e.toString()).toList();
    SP.write("selected_list", value);
    if (learn == true && unlearn != true) {
      _words = await DB.instance.readWordByLists(selectedListID, status: true);
    } else if (learn != true && unlearn == true) {
      _words = await DB.instance.readWordByLists(selectedListID, status: false);
    } else {
      _words = await DB.instance.readWordByLists(
        selectedListID,
      );
    }

    if (_words.isNotEmpty) {
      for (int i = 0; i < _words.length; i++) {
        changeLand.add(true);
      }
      if (listMixed) _words.shuffle();
      start = true;
      setState(() {
        start;
        _words;
      });
    } else {
      toastMessage("Seçilen şartlar liste boş.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff00b2ca),
      appBar: appbar(
        context,
        left: start == false
            ? const Icon(
                Icons.arrow_back_ios,
                color: Color(0xffF3FBF8),
                size: 22,
              )
            : InkWell(
                onTap: () {
                  setState(() {
                    start = false;
                  });
                },
                child: const Icon(
                  Icons.highlight_off_outlined,
                  color: Color(0xffF3FBF8),
                  size: 31,
                ),
              ),
        center: start == false
            ? const Text(
                "Yeni Kart Destesi",
                style: TextStyle(
                    fontFamily: "Carter",
                    color: Color(0xffF3FBF8),
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
              )
            : svgLogoIcon,
        leftWidgetOnClik: () => start == false ? Navigator.pop(context) : start = false,
      ),
      body: Container(
          child: start == false
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    left: 15,
                    top: 40,
                  ),
                  decoration: const BoxDecoration(
                      color: Color(0xffF3FBF8),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text(
                      "İçerik",
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff333333),
                          fontWeight: FontWeight.w700),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (learn == false) {
                              learn = true;
                            } else {
                              learn = false;
                            }
                            setState(() {
                              learn;
                            });
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
                                style: learn == false
                                    ? const TextStyle(
                                        fontSize: 15, color: Color(0xffBDBDBD))
                                    : const TextStyle(
                                        fontSize: 15, color: Color(0xff4F4F4F)),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (unlearn == false) {
                              unlearn = true;
                            } else {
                              unlearn = false;
                            }
                            setState(() {
                              unlearn;
                            });
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
                                style: unlearn == false
                                    ? const TextStyle(
                                        fontSize: 15, color: Color(0xffBDBDBD))
                                    : const TextStyle(
                                        fontSize: 15, color: Color(0xff4F4F4F)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text("Kaynak Listeler",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
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
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          const Text(
                            "Listeyi Karıştır",
                            style: TextStyle(
                                fontFamily: 'RobotoRegular',
                                fontSize: 16,
                                color: Color(0xff4F4F4F)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: FlutterSwitch(
                              activeTextColor: Colors.white,
                              inactiveTextColor: const Color(0xff828282),
                              width: 88.0,
                              height: 34.0,
                              valueFontSize: 14.0,
                              activeColor: const Color(0xff00b2ca),
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
                              color: Color(0xff00b2ca),
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(right: 20),
                          child: InkWell(
                            onTap: () {
                              if (learn == false && unlearn == false) {
                                toastMessage("Lütfen, liste seçiniz");
                              } else {
                                /* setState(() {
                                  if (learn == true && unlearn == true) {
                                    SP.write("which", 2);
                                    Which.all;
                                  } else if (learn == true) {
                                    SP.write("which", 0);
                                    Which.learned;
                                  } else if (unlearn == true) {
                                    SP.write("which", 1);
                                    Which.unlearned;
                                  }
                                });*/
                                List<int> selectedIndexNoOfList = [];
                                for (int i = 0; i < selectedListIndex.length; i++) {
                                  if (selectedListIndex[i] == true) {
                                    selectedIndexNoOfList.add(i);
                                  }
                                }
                                List<int> selectedListIdList = [];
                                for (int i = 0; i < selectedIndexNoOfList.length; i++) {
                                  selectedListIdList.add(
                                      lists[selectedIndexNoOfList[i]]['list_id'] as int);
                                }
                                if (selectedListIdList.isNotEmpty) {
                                  getSelectedWordOfLists(selectedListIdList);
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
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    )
                  ]),
                )
              : CarouselSlider.builder(
                  options: CarouselOptions(
                    height: double.infinity,
                    viewportFraction: 1,
                                        
                    
                  ),
                  itemCount: _words.length,
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                    String word = "";
                    if (chooeseLang == Lang.tr) {
                      word = changeLand[itemIndex]
                          ? _words[itemIndex].word_tr!
                          : _words[itemIndex].word_eng!;
                    } else {
                      word = changeLand[itemIndex]
                          ? _words[itemIndex].word_eng!
                          : _words[itemIndex].word_tr!;
                    }
                    return Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Color(0xffF3FBF8),
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                          width: 385,
                          height: 285,
                          child: Stack(children: [
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(
                                  left: 16, right: 16, top: 8, bottom: 16),
                              padding: const EdgeInsets.only(left: 4, top: 15, right: 4),
                              child: Text(
                                word,
                                style: const TextStyle(
                                    fontFamily: "RobotoRegular",
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
                                    color: Color(0xff3574C3),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10))),
                                child: Text(
                                  "${itemIndex + 1}/${_words.length}",
                                  style:
                                      const TextStyle(fontSize: 14, color: Colors.white),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 40,
                              bottom: 0,
                              child: Container(
                                  alignment: Alignment.center,
                                  width: 60,
                                  height: 60,
                                  decoration: const BoxDecoration(
                                      color: Color(0xff3574C3),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10))),
                                  child: InkWell(
                                      onTap: () {
                                        if (changeLand[itemIndex] == true) {
                                          changeLand[itemIndex] = false;
                                        } else {
                                          changeLand[itemIndex] = true;
                                        }
                                        setState(() {
                                          changeLand;
                                        });
                                      },
                                      child: changeLand[itemIndex] == true? const Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 40,
                                        color: Colors.white,
                                      ):const Icon(
                                        IconData(0xf662) ,
                                       
                                        size: 40,
                                        color: Colors.white,
                                      ))),
                            ),
                          ]),
                        ),
                        SizedBox(
                          width: 160,
                          child: CheckboxListTile(
                            title: const Text(
                              "Öğrendim",
                              style: TextStyle(
                                  fontFamily: "RobotoRegular",
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            value: _words[itemIndex].status,
                            onChanged: (value) {
                              _words[itemIndex] = _words[itemIndex].copy(status: value);
                              DB.instance
                                  .markAslearned(value!, _words[itemIndex].id as int);
                              toastMessage(value
                                  ? "Öğrenildi olarak işaretlendi"
                                  : "Öğrenilmedi olarak işaretlendi.");

                              setState(() {
                                _words[itemIndex];
                              });
                            },
                          ),
                        )
                      ],
                    );
                  })),
    );
  }

  Container checkBox({int index = 0, String? text}) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
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
                fontFamily: 'RobotoRegular', fontSize: 16, color: Color(0xff4F4F4F)),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Checkbox(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            checkColor: Colors.white,
            activeColor: const Color(0xff00b2ca),
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
