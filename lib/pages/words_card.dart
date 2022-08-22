import 'package:english/db/models/words.dart';
import 'package:english/global_variable.dart';
import 'package:english/global_widget/app_bar.dart';
import 'package:english/global_widget/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../db/db/db.dart';

class WordCardspage extends StatefulWidget {
  const WordCardspage({Key? key}) : super(key: key);

  @override
  State<WordCardspage> createState() => _WordCardspageState();
}

enum Which { learned, unlearned, all }

enum forWhat { fortList, fortListMixed }

class _WordCardspageState extends State<WordCardspage> {
  Which? _chooseQuwstionType = Which.learned;
  bool listMixed = true;
  List<Map<String, Object?>> _lists = [];
  List<bool> selectedListIndex = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLists();
  }

  void getLists() async {
    _lists = await DB.instance.readListAll();
    for (int i = 0; i < _lists.length; i++) {
      selectedListIndex.add(false);
    }

    setState(() {
      _lists;
    });
  }

  List<Word> _words = [];
  bool start = false;
  List<bool> changeLand = [];

  void getSelectedWordOfLists(List<int> selectedListID) async {
    if (_chooseQuwstionType == Which.learned) {
      _words = await DB.instance.readWordByLists(selectedListID, status: true);
    } else if (_chooseQuwstionType == Which.unlearned) {
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
      appBar: appbar(
        context,
        left: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 22,
        ),
        center: const Text(
          "Kelime Kartları",
          style: TextStyle(fontFamily: 'carter', color: Colors.black, fontSize: 22),
        ),
        leftWidgetOnClik: () => Navigator.pop(context),
      ),
      body: SafeArea(
          child: start == false
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                  padding: const EdgeInsets.only(left: 4, top: 15, right: 4),
                  decoration: const BoxDecoration(
                      color: Color(0xffDCD2FF),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    whichRadioButton(text: "Öğrendinlerimi sor", value: Which.learned),
                    whichRadioButton(text: "Öğrenmediklerimi sor", value: Which.unlearned),
                    whichRadioButton(text: "Hepsini sor", value: Which.all),
                    checkBox(text: "Listeyi karıştır", fwhat: forWhat.fortListMixed),
                    const SizedBox(height: 20),
                    const Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text("Listeler",
                          style: TextStyle(
                              fontFamily: 'RobotoRegular',
                              fontSize: 18,
                              color: Colors.black)),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
                      height: 200,
                      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
                      child: Scrollbar(
                        thickness: 5,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return checkBox(
                                index: index, text: _lists[index]['name'].toString());
                          },
                          itemCount: _lists.length,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(right: 20),
                      child: InkWell(
                        onTap: () {
                          List<int> selectedIndexNoOfList = [];
                          for (int i = 0; i < selectedListIndex.length; i++) {
                            if (selectedListIndex[i] == true) {
                              selectedIndexNoOfList.add(i);
                            }
                          }
                          List<int> selectedListIdList = [];
                          for (int i = 0; i < selectedIndexNoOfList.length; i++) {
                            selectedListIdList
                                .add(_lists[selectedIndexNoOfList[i]]['list_id'] as int);
                          }
                          if (selectedListIdList.isNotEmpty) {
                            getSelectedWordOfLists(selectedListIdList);
                          } else {
                            toastMessage("Lütfen, liste seçiniz");
                          }
                        },
                        child: const Text(
                          "Başla",
                          style: TextStyle(
                              fontFamily: "RobotoRegular",
                              fontSize: 18,
                              color: Colors.black),
                        ),
                      ),
                    )
                  ]),
                )
              : CarouselSlider.builder(
                  options: CarouselOptions(height: double.infinity),
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
                        Expanded(
                          child: Stack(children: [
                            InkWell(
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
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(
                                    left: 16, right: 16, top: 8, bottom: 16),
                                padding: const EdgeInsets.only(left: 4, top: 15, right: 4),
                                decoration: const BoxDecoration(
                                    color: Color(0xffDCD2FF),
                                    borderRadius: BorderRadius.all(Radius.circular(8))),
                                child: Text(
                                  word,
                                  style: const TextStyle(
                                      fontFamily: "RobotoRegular",
                                      fontSize: 28,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 30,
                              top: 10,
                              child: Text(
                                "${itemIndex + 1}/${_words.length}",
                                style: const TextStyle(
                                    fontFamily: "RobotoRegular",
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                            )
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

  SizedBox whichRadioButton({@required String? text, @required Which? value}) {
    return SizedBox(
      width: 275,
      height: 32,
      child: ListTile(
        title: Text(
          text!,
          style: const TextStyle(fontFamily: 'RobotoRegular', fontSize: 18),
        ),
        leading: Radio<Which>(
          value: value!,
          groupValue: _chooseQuwstionType,
          onChanged: (Which? value) {
            setState(() {
              _chooseQuwstionType = value;
            });
          },
        ),
      ),
    );
  }

  SizedBox checkBox({int index = 0, String? text, forWhat fwhat = forWhat.fortList}) {
    return SizedBox(
      width: 270,
      height: 35,
      child: ListTile(
        title: Text(
          text!,
          style: const TextStyle(fontFamily: 'RobotoRegular', fontSize: 18),
        ),
        leading: Checkbox(
          checkColor: Colors.white,
          activeColor: Colors.deepPurpleAccent,
          hoverColor: Colors.blueAccent,
          value: fwhat == forWhat.fortList ? selectedListIndex[index] : listMixed,
          onChanged: (bool? value) {
            setState(() {
              if (fwhat == forWhat.fortList) {
                selectedListIndex[index] = value!;
              } else {
                listMixed = value!;
              }
            });
          },
        ),
      ),
    );
  }
}
