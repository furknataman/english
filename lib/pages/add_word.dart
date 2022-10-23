// ignore_for_file: prefer_is_not_empty

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../db/db/db.dart';
import '../db/models/words.dart';
import '../global_widget/app_bar.dart';
import '../global_widget/text_filed.dart';
import '../global_widget/toast_message.dart';

class addWordPage extends StatefulWidget {
  final int? listID;
  final String? ListName;
  const addWordPage(this.listID, this.ListName, {Key? key}) : super(key: key);

  @override
  State<addWordPage> createState() =>
      _addWordPageState(ListID: listID, ListName: ListName);
}

class _addWordPageState extends State<addWordPage> {
  int? ListID;
  String? ListName;
  _addWordPageState({@required this.ListID, @required this.ListName});

  List<TextEditingController> wordTextEditingList = [];
  List<Row> wordListField = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; ++i) {
      wordTextEditingList.add(TextEditingController());
    }

    for (int i = 0; i < 3; ++i) {
      wordListField.add(Row(
        children: [
          Expanded(
              child: textFieldBuilder(
                  padding: const EdgeInsets.only(left: 4),
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
      appBar: appbar(context,
          left: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xffF3FBF8),
            size: 22,
          ),
          center: Text(
            ListName!,
            style: const TextStyle(
                color: Color(0xffF3FBF8), fontSize: 22, fontWeight: FontWeight.w600),
          ),
          leftWidgetOnClik: () => Navigator.pop(context)),
      body: SafeArea(
        child: Container(
          color: const Color(0xffF3FBF8),
          child: Column(children: [
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
                    ),
                  ),
                  Text(
                    "Türkçe",
                    style: TextStyle(
                      color: Color(0xff4F4F4F),
                      fontSize: 18,
                    ),
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
                actionsbutons(addRow, Icons.add),
                actionsbutons(save, Icons.save),
                actionsbutons(deleteRow, Icons.remove)
              ],
            )
          ]),
        ),
      ),
    );
  }

  InkWell actionsbutons(Function() click, IconData icon) {
    return InkWell(
      onTap: () => click(),
      child: Container(
        height: 40,
        width: 40,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: const BoxDecoration(
            color: Color.fromRGBO(157, 192, 198, 0.9), shape: BoxShape.circle),
        child: Icon(
          icon,
          size: 28,
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
        for (int i = 0; i < wordTextEditingList.length / 2; i++) {
          String eng = wordTextEditingList[2 * i].text;
          String tr = wordTextEditingList[2 * i + 1].text;
          Word word = await DB.instance.insertWord(
              Word(list_id: ListID, word_eng: eng, word_tr: tr, status: false));
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
    if (wordListField.length != 1) {
      wordTextEditingList.removeAt(wordTextEditingList.length - 1);
      wordTextEditingList.removeAt(wordTextEditingList.length - 1);

      wordListField.removeAt(wordListField.length - 1);

      setState(() => wordListField);
    } else {
      toastMessage("En az 1 çift gereklidir.");
    }
  }
}
