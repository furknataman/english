// ignore_for_file: prefer_is_not_empty

import 'package:english/db/models/lists.dart';
import 'package:english/global_widget/app_bar.dart';
import 'package:english/global_widget/toast_message.dart';
import 'package:flutter/material.dart';
import '../db/db/db.dart';
import '../db/models/words.dart';
import '../global_widget/text_filed.dart';

class AddList extends StatefulWidget {
  const AddList({Key? key}) : super(key: key);

  @override
  State<AddList> createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  final _listName = TextEditingController();
  List<TextEditingController> wordTextEditingList = [];
  List<Row> wordListField = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 10; ++i) {
      wordTextEditingList.add(TextEditingController());
    }

    for (int i = 0; i < 5; ++i) {
      wordListField.add(Row(
        children: [
          Expanded(
              child: textFieldBuilder(
                  padding: const EdgeInsets.only(left: 3),
                  textEditingController: wordTextEditingList[2 * i])),
          Expanded(
              child: textFieldBuilder(
                  padding: const EdgeInsets.only(right: 4),
                  textEditingController: wordTextEditingList[2 * i + 1])),
        ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(
        context,
        left: const Icon(
          Icons.arrow_back_ios,
          color: Color(0xffF3FBF8),
          size: 22,
        ),
        center: const Text("Liste Oluştur",
            style: TextStyle(
                color: Color(0xffF3FBF8), fontSize: 22, fontWeight: FontWeight.w600)),
        leftWidgetOnClik: () => {Navigator.pop(context)},
      ),
      body: SafeArea(
        child: Container(
          color: const Color(0xffF3FBF8),
          child: Column(children: [
            textFieldBuilder(
                padding: const EdgeInsets.only(left: 4, right: 4),
                icon: const Icon(
                  Icons.list,
                  size: 18,
                ),
                hindText: "Liste Adı",
                textEditingController: _listName,
                textAlign: TextAlign.left),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
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
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                children: wordListField,
              )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                actionsbutons(addRow, Icons.add, 0xffF2C94C),
                actionsbutons(save, Icons.save,0xff6FCF97),
                actionsbutons(deleteRow, Icons.remove,0xffEB5757)
              ],
            )
          ]),
        ),
      ),
    );
  }

  InkWell actionsbutons(Function() click, IconData icon,int? color) {
    return InkWell(
      onTap: () => click(),
      child: Container(
        height: 40,
        width: 40,
        margin: const EdgeInsets.only(bottom: 15),
        decoration:
             BoxDecoration(color:  Color(color!), shape: BoxShape.circle),
        child: Icon(
          icon,
          size: 28,
          color: Colors.white,
        ),
      ),
    );
  }

  void addRow() {
    wordTextEditingList.add(TextEditingController());
    wordTextEditingList.add(TextEditingController());

    wordListField.add(Row(
      children: [
        Expanded(
            child: textFieldBuilder(
                padding: const EdgeInsets.only(left: 4),
                textEditingController:
                    wordTextEditingList[wordTextEditingList.length - 2])),
        Expanded(
            child: textFieldBuilder(
                padding: const EdgeInsets.only(right: 4),
                textEditingController:
                    wordTextEditingList[wordTextEditingList.length - 1])),
      ],
    ));
    setState((() => wordListField));
  }

  void save() async {
    if (_listName.text.isNotEmpty) {
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

      if (counter > 3) {
        if (!notEmptyPair) {
          Lists addedList = await DB.instance.insertList(Lists(name: _listName.text));

          for (int i = 0; i < wordTextEditingList.length / 2; i++) {
            String eng = wordTextEditingList[2 * i].text;
            String tr = wordTextEditingList[2 * i + 1].text;
            Word word = await DB.instance.insertWord(
                Word(list_id: addedList.id, word_eng: eng, word_tr: tr, status: false));
            //debugPrint(
            //  "${word.id} ${word.list_id}  ${word.word_eng} ${word.word_tr} ${word.status}");
          }

          toastMessage("Liste oluşturuldu");
          _listName.clear();
          for (var element in wordTextEditingList) {
            element.clear();
          }
        } else {
          toastMessage("Alanlar boş bırakılamaz. Silin veya doldurun.");
        }
      } else {
        toastMessage("En az dört çift dolu olmalıdır.");
      }
    } else {
      toastMessage("Lütfen liste adını girin");
    }
  }

  void deleteRow() {
    if (wordListField.length != 4) {
      wordTextEditingList.removeAt(wordTextEditingList.length - 1);
      wordTextEditingList.removeAt(wordTextEditingList.length - 1);

      wordListField.removeAt(wordListField.length - 1);

      setState(() => wordListField);
    } else {
      toastMessage("En az dört çift gereklidir.");
    }
  }
}
