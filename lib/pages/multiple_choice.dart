import 'dart:math';

import 'package:english/db/models/words.dart';
import 'package:english/global_variable.dart';
import 'package:english/global_widget/app_bar.dart';
import 'package:english/global_widget/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../db/db/db.dart';

class MultipleChoicePage extends StatefulWidget {
  const MultipleChoicePage({Key? key}) : super(key: key);

  @override
  State<MultipleChoicePage> createState() => _MultipleChoicePage();
}

enum Which { learned, unlearned, all }

enum forWhat { fortList, fortListMixed }

class _MultipleChoicePage extends State<MultipleChoicePage> {
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

  List<List<String>> optionsList = [];
  List<String> correctAnswers = [];

  List<bool> clickControl = [];
  List<List<bool>> clickControlList = [];

  int correctCount = 0;
  int wrongCount = 0;

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
      if (_words.length > 3) {
        if (listMixed) _words.shuffle();

        Random random = Random();
        for (int i = 0; i < _words.length; i++) {
          clickControl.add(false);

          clickControlList.add([false, false, false, false]);

          List<String> tempOptions = [];
          while (true) {
            int rand = random.nextInt(_words.length);
            if (rand != i) {
              bool isThereSame = false;
              for (var element in tempOptions) {
                if (chooeseLang == Lang.eng) {
                  if (element == _words[rand].word_tr!) {
                    isThereSame = true;
                  }
                }
                 else {
                  if (element == _words[rand].word_eng!) {
                    isThereSame = true;
                  }
                }
              }

              if (!isThereSame) {
                tempOptions.add(chooeseLang == Lang.eng
                    ? _words[rand].word_tr!
                    : _words[rand].word_eng!);
              }
            }

            if (tempOptions.length == 3) {
              break;
            }
          }
          tempOptions.add(chooeseLang == Lang.eng?_words[i].word_tr!:_words[i].word_eng!);
          tempOptions.shuffle();
          correctAnswers.add(chooeseLang == Lang.eng?_words[i].word_tr!:_words[i].word_eng!);
          optionsList.add(tempOptions);
        }

        start = true;
        setState(() {
          start;
          _words;
        });
      } else {
        toastMessage("En az 4 kelime gereklidir.");
      }
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
          "Çoktan Seçmeli",
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
                    return Column(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(
                                    left: 16, right: 16, top: 8, bottom: 16),
                                padding: const EdgeInsets.only(left: 4, top: 15, right: 4),
                                decoration: const BoxDecoration(
                                    color: Color(0xffDCD2FF),
                                    borderRadius: BorderRadius.all(Radius.circular(8))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      chooeseLang==Lang.eng? _words[itemIndex].word_eng!:_words[itemIndex].word_tr!,
                                      style: const TextStyle(
                                          fontFamily: "RobotoRegular",
                                          fontSize: 28,
                                          color: Colors.black),
                                    ),
                                    customRadioButtonList(itemIndex,
                                        optionsList[itemIndex], correctAnswers[itemIndex])
                                  ],
                                ),
                              ),
                              Positioned(
                                  left: 30,
                                  top: 10,
                                  child: Text(
                                    (itemIndex + 1).toString() +
                                        "/" +
                                        (_words.length).toString(),
                                    style: const TextStyle(
                                        fontFamily: "RobotoRegular",
                                        fontSize: 16,
                                        color: Colors.black),
                                  )),
                              Positioned(
                                  right: 30,
                                  top: 10,
                                  child: Text(
                                    "D:" +
                                        correctCount.toString() +
                                        "/" +
                                        "Y:" +
                                        wrongCount.toString(),
                                    style: const TextStyle(
                                        fontFamily: "RobotoRegular",
                                        fontSize: 16,
                                        color: Colors.black),
                                  )),
                            ],
                          ),
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

  Container customRadioButton(int index, List<String> options, int order) {
    Icon uncheck = const Icon(Icons.radio_button_off_outlined, size: 16);
    Icon check = const Icon(Icons.radio_button_checked_outlined, size: 16);
    return Container(
      margin: const EdgeInsets.all(4),
      child: Row(children: [
        clickControlList[index][order] == false ? uncheck : check,
        const SizedBox(
          width: 10,
        ),
        Text(
          options[order],
          style: const TextStyle(fontSize: 18),
        )
      ]),
    );
  }

  Column customRadioButtonList(int index, List<String> options, String correctAnswers) {
    Divider dV = const Divider(
      thickness: 1,
      height: 1,
    );
    return Column(
      children: [
        dV,
        InkWell(
          onTap: () => toastMessage("Seçmej için çift tıklayın"),
          onDoubleTap: () => checher(index, 0, options, correctAnswers),
          child: customRadioButton(index, options, 0),
        ),
        dV,
        InkWell(
          onTap: () => toastMessage("Seçmej için çift tıklayın"),
          onDoubleTap: () => checher(index, 1, options, correctAnswers),
          child: customRadioButton(index, options, 1),
        ),
        dV,
        InkWell(
          onTap: () => toastMessage("Seçmej için çift tıklayın"),
          onDoubleTap: () => checher(index, 2, options, correctAnswers),
          child: customRadioButton(index, options, 2),
        ),
        dV,
        InkWell(
          onTap: () => toastMessage("Seçmej için çift tıklayın"),
          onDoubleTap: () => checher(index, 3, options, correctAnswers),
          child: customRadioButton(index, options, 3),
        ),
      ],
    );
  }

  void checher(index, order, options, correctAnswers) {
    if (clickControl[index] == false) {
      clickControl[index] = true;

      setState(() {
        clickControlList[index][order] = true;
      });
      if (options[order] == correctAnswers) {
        correctCount++;
      } else {
        wrongCount++;
      }
      if ((correctAnswers + wrongCount) == _words.length) {
        toastMessage("Test Bitti");
      }
    }
  }
}
