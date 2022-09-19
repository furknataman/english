import 'package:english/db/models/lists.dart';
import 'package:english/global_widget/app_bar.dart';
import 'package:english/global_widget/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    for (int i = 0; i < 10; ++i) wordTextEditingList.add(TextEditingController());

    for (int i = 0; i < 5; ++i) {
      wordListField.add(Row(
        children: [
          Expanded(
              child: textFieldBuilder(textEditingController: wordTextEditingList[2 * i])),
          Expanded(
              child:
                  textFieldBuilder(textEditingController: wordTextEditingList[2 * i + 1])),
        ],
      ));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(
        context,
        left: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 22,
        ),
        center: Image.asset("assets/images/logo_text.png"),
        right: Image.asset(
          "assets/images/logo.png",
          height: 60,
          width: 60,
        ),
        leftWidgetOnClik: () => {Navigator.pop(context)},
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(children: [
            textFieldBuilder(
                icon: const Icon(
                  Icons.list,
                  size: 18,
                ),
                hindText: "Liste Adı",
                textEditingController: _listName,
                textAlign: TextAlign.left),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "İngilizce",
                    style: TextStyle(fontSize: 18, fontFamily: "RobotoRegular"),
                  ),
                  Text(
                    "Türkçe",
                    style: TextStyle(fontSize: 18, fontFamily: "RobotoRegular"),
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
        margin: EdgeInsets.only(bottom: 15),
        child: Icon(
          icon,
          size: 28,
        ),
        decoration: BoxDecoration(color: Color(0xffDCD2FF), shape: BoxShape.circle),
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
                textEditingController:
                    wordTextEditingList[wordTextEditingList.length - 2])),
        Expanded(
            child: textFieldBuilder(
                textEditingController:
                    wordTextEditingList[wordTextEditingList.length - 1])),
      ],
    ));
    setState((() => wordListField));
  }

  void save() async {
    if (!_listName.text.isEmpty) {
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

      if (counter > 4) {
        if (!notEmptyPair) {
          Lists addedList = await DB.instance.insertList(Lists(name: _listName.text));

          for (int i = 0; i < wordTextEditingList.length / 2; i++) {
            String eng = wordTextEditingList[2 * i].text;
            String tr = wordTextEditingList[2 * i + 1].text;
            Word word = await DB.instance.insertWord(
                Word(list_id: addedList.id, word_eng: eng, word_tr: tr, status: false));
            debugPrint(
                "${word.id} ${word.list_id}  ${word.word_eng} ${word.word_tr} ${word.status}");
          }

          toastMessage("Liste oluşturuldu");
          _listName.clear();
          wordTextEditingList.forEach((element) {
            element.clear();
          });
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
