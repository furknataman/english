// ignore_for_file: prefer_is_not_empty

import 'package:flutter/material.dart';
import '../db/db/db.dart';
import '../db/models/words.dart';
import '../global_widget/app_bar.dart';
import '../global_widget/text_filed.dart';
import '../global_widget/toast_message.dart';

class AddWordPage extends StatefulWidget {
  final int? listID;
  final String? listName;
  const AddWordPage(this.listID, this.listName, {Key? key}) : super(key: key);

  @override
  State<AddWordPage> createState() =>
      _AddWordPageState(listID: listID, listName: listName);
}

class _AddWordPageState extends State<AddWordPage> {
  int? listID;
  String? listName;
  _AddWordPageState({@required this.listID, @required this.listName});

  List<TextEditingController> wordTextEditingList = [];
  List<Row> wordListField = [];
  List<Word> _wordlist = [];
  List<Word> dbWordList = [];
  List<bool> deleteIndexList = [];
  bool editController = false;
  int listItem = 0;

  void getWordByList() async {
    _wordlist = await DB.instance.readWordByList(listID);
    dbWordList = _wordlist;

    for (int i = 0; i < _wordlist.length; i++) {
      deleteIndexList.add(false);
    }
    for (int i = 0; i < _wordlist.length * 2; ++i) {
      wordTextEditingList.add(TextEditingController());
    }
    setState(() {
      listItem = _wordlist.length;
      _wordlist;
      wordTextEditingList;
      wordListField;
      dbWordList;
    });
  }

  void delete() async {
    List<int> removeIndexLits = [];
    //print(deleteIndexList);
    for (int i = 0; i < deleteIndexList.length; i++) {
      if (deleteIndexList[i] == true) {
        removeIndexLits.add(i);
      }
    }

    for (int i = removeIndexLits.length - 1; i >= 0; i--) {
      DB.instance.deleteWord(_wordlist[removeIndexLits[i]].id!);
      _wordlist.removeAt(removeIndexLits[i]);
      deleteIndexList.removeAt(removeIndexLits[i]);
    }
    setState(() {
      _wordlist;
      deleteIndexList;
    });
    toastMessage("Seçili kelimeler silindi");
  }

  void learn() async {
    List<int> learnIndexList = [];
    for (int i = 0; i < deleteIndexList.length; i++) {
      if (deleteIndexList[i] == true) {
        learnIndexList.add(i);
      }
    }
    for (int i = learnIndexList.length - 1; i >= 0; i--) {
      DB.instance.markAslearned(true, _wordlist[i].id as int);

      deleteIndexList[i] = false;
    }
    setState(() {
      deleteIndexList;
      learnIndexList;
      _wordlist;
    });

    toastMessage("Seçili Kelimeler Öğrenildi olara işaretlendi");
  }

  void unlearn() async {
    List<int> learnIndexList = [];
    for (int i = 0; i < deleteIndexList.length; i++) {
      if (deleteIndexList[i] == true) {
        learnIndexList.add(i);
      }
    }
    for (int i = learnIndexList.length - 1; i >= 0; i--) {
      DB.instance.markAslearned(false, _wordlist[i].id as int);

      deleteIndexList[i] = false;
    }
    setState(() {
      deleteIndexList;
      learnIndexList;
      _wordlist;
    });
    toastMessage("Seçili Kelimeler Öğrenilmedi olara işaretlendi");
  }

  @override
  void initState() {
    super.initState();
    getWordByList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3574C3),
      appBar: appbar(context,
          left: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xffF3FBF8),
            size: 22,
          ),
          center: Text(
            listName!,
            style: const TextStyle(
                color: Color(0xffF3FBF8), fontSize: 22, fontWeight: FontWeight.w600),
          ),
          leftWidgetOnClik: () => Navigator.pop(context)),
      body: Column(
        children: [
          SizedBox(
            height: 70,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 14),
              child: editController == false
                  ? Row(children: [
                      InkWell(
                        onTap: () {
                          editController = true;

                          setState(() {
                            editController;
                          });
                        },
                        child: card(
                            icon: Icons.create_outlined,
                            iconColor: 0xffF2C94C,
                            cardColor: 0xffF3FBF8),
                      ),
                    ])
                  : Row(children: [
                      card(
                          icon: Icons.create_outlined,
                          iconColor: 0xff828282,
                          cardColor: 0xffE0E0E0),
                      InkWell(
                        onTap: () {
                          editController = false;

                          setState(() {
                            editController;
                          });
                        },
                        child: card(
                            icon: Icons.close,
                            iconColor: 0xff4F4F4F,
                            cardColor: 0xffF3FBF8),
                      ),
                      InkWell(
                        onTap: () {
                          addRow();
                        },
                        child: card(
                            icon: Icons.add_circle_outline,
                            iconColor: 0xff6FCF97,
                            cardColor: 0xffF3FBF8),
                      ),
                      const SizedBox(
                        width: 210,
                      ),
                      InkWell(
                        onTap: () {
                          save();
                        },
                        child: card(
                            icon: Icons.save_rounded,
                            iconColor: 0xff6FCF97,
                            cardColor: 0xffF3FBF8),
                      ),
                    ]),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Color(0xff002250),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20), topRight: Radius.circular(20))),
              child: Column(children: [
                if (editController == true)
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 10),
                    height: 70,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          "Seçilen Kelimeleri... ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [
                            editingButton(text: "Öğren", width: 71, click: learn),
                            editingButton(text: "Unut", width: 64, click: unlearn),
                            editingButton(text: "Sil", width: 48, click: delete),
                          ],
                        )
                      ],
                    ),
                  ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color(0xffF3FBF8),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                    child: Column(children: [
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        height: 40,
                        decoration: const BoxDecoration(
                            color: Color(0xffF3FBF8),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Text(
                              "İngilizce",
                              style: TextStyle(
                                  color: Color(0xff4F4F4F),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "Türkçe",
                              style: TextStyle(
                                color: Color(0xff4F4F4F),
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xffF3FBF8),
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                          child: ListView.builder(
                              itemBuilder: (context, index) {
                                return list(index,
                                    wordTr: _wordlist[index].word_tr,
                                    wordEng: _wordlist[index].word_eng,
                                    learn: _wordlist[index].status);
                              },
                              itemCount: _wordlist.length),
                        ),
                      ),
                    ]),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Row list(
    int index, {
    @required String? wordTr,
    @required String? wordEng,
    @required bool? learn,
  }) {
    wordTextEditingList[2 * index + 1].text = wordTr!;
    wordTextEditingList[2 * index].text = wordEng!;
    Color? color;
    if (learn!) {
      color = const Color.fromARGB(255, 102, 210, 147);
    } else {
      color = const Color(0xff3574C3);
    }

    return Row(
      children: [
        Expanded(
            child: textFieldBuilder(
                borderColor: color,
                editting: editController,
                padding: const EdgeInsets.only(left: 4),
                textEditingController: wordTextEditingList[2 * index])),
        Expanded(
            child: textFieldBuilder(
                borderColor: color,
                editting: editController,
                padding: const EdgeInsets.only(right: 2),
                textEditingController: wordTextEditingList[2 * index + 1])),
        editController
            ? Container(
                padding: const EdgeInsets.only(top: 10),
                margin: const EdgeInsets.only(
                  right: 15,
                ),
                width: 20,
                height: 30,
                child: Checkbox(
                  side: const BorderSide(color: Colors.black),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  checkColor: Colors.white,
                  activeColor: const Color(0xff3574C3),
                  hoverColor: Colors.blueAccent,
                  value: deleteIndexList[index],
                  onChanged: (bool? value) {
                    if (deleteIndexList[index]) {
                      deleteIndexList[index] = false;
                    } else {
                      deleteIndexList[index] = true;
                    }
                    setState(() {
                      deleteIndexList[index];
                    });
                  },
                ),
              )
            : Container(),
      ],
    );
  }

  void addRow() async {
    wordTextEditingList.add(TextEditingController());
    wordTextEditingList.add(TextEditingController());
    deleteIndexList.add(false);
    Word word = await DB.instance
        .insertWord(Word(list_id: listID, word_eng: " ", word_tr: "", status: false));
    _wordlist.add(word);
    setState(() {
      wordListField;
      deleteIndexList;
      _wordlist;
    });
  }

  void save() async {
    int counter = 0;
    bool notEmptyPair = false;
    for (int i = 0; i < wordTextEditingList.length / 2; i++) {
      String eng = wordTextEditingList[2 * i].text;
      String tr = wordTextEditingList[2 * i + 1].text;

      if (!eng.isEmpty && !tr.isEmpty) {
        counter++;
      } else {
        notEmptyPair = true;
      }
    }

    if (counter > 1) {
      if (!notEmptyPair) {
        for (int i = _wordlist.length - 1; i >= 0; i--) {
          DB.instance.deleteWord(_wordlist[i].id!);
        }

        for (int i = 0; i < wordTextEditingList.length / 2; i++) {
          String eng = wordTextEditingList[2 * i].text;
          String tr = wordTextEditingList[2 * i + 1].text;
          Word word = await DB.instance.insertWord(
              Word(list_id: listID, word_eng: eng, word_tr: tr, status: false));
          //debugPrint(
          //  "${word.id} ${word.list_id}  ${word.word_eng} ${word.word_tr} ${word.status}");
        }

        toastMessage("Kelimeler eklendi");
        for (var element in wordTextEditingList) {
          element.clear();
        }
      } else {
        toastMessage("Alanlar boş bırakılamaz. Silin veya doldurun.");
      }
    } else {
      toastMessage("En az 1 çift dolu olmalıdır.");
    }
  }

  void deleteRow() {
    if (wordListField.length > _wordlist.length) {
      wordTextEditingList.removeAt(wordTextEditingList.length - 1);
      wordTextEditingList.removeAt(wordTextEditingList.length - 1);

      wordListField.removeAt(wordListField.length - 1);

      setState(() => wordListField);
    } else {
      toastMessage("Kayıtlı Kelimeleri silmek için lütfen menüyü kullanın");
    }
  }

  Container card({IconData? icon, @required int? iconColor, @required int? cardColor}) {
    return Container(
      margin: const EdgeInsets.only(
        left: 8,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color(cardColor!),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      width: 38,
      height: 38,
      child: Icon(
        icon,
        color: Color(iconColor!),
        size: 32,
      ),
    );
  }

  InkWell editingButton(
      {@required Function()? click, @required String? text, @required double? width}) {
    return InkWell(
      onTap: () => click!(),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        alignment: Alignment.center,
        width: width,
        height: 38,
        decoration: const BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Text(
          text!,
          style: const TextStyle(
              color: Color(0xff4F4F4F), fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
