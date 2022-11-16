import 'package:flutter/cupertino.dart';
import '../db/db/db.dart';
import '../db/models/lists.dart';
import '../db/models/words.dart';
import '../global_widget/text_filed.dart';
import '../global_widget/toast_message.dart';

class AddListProvider extends ChangeNotifier {
  final listName = TextEditingController();
  List<TextEditingController> wordTextEditingList = [];
  List<Row> wordListField = [];

  void getField() {
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
    notifyListeners();
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
    notifyListeners();
  }

  void save() async {
    if (listName.text.isNotEmpty) {
      int counter = 0;
      bool notEmptyPair = false;
      for (int i = 0; i < wordTextEditingList.length / 2; i++) {
        String eng = wordTextEditingList[2 * i].text;
        String tr = wordTextEditingList[2 * i + 1].text;

        if (eng.isNotEmpty && tr.isNotEmpty) {
          counter++;
        } else {
          notEmptyPair = true;
        }
      }

      if (counter > 3) {
        if (!notEmptyPair) {
          Lists addedList = await DB.instance.insertList(Lists(name: listName.text));

          for (int i = 0; i < wordTextEditingList.length / 2; i++) {
            String eng = wordTextEditingList[2 * i].text;
            String tr = wordTextEditingList[2 * i + 1].text;
            await DB.instance.insertWord(
                Word(list_id: addedList.id, word_eng: eng, word_tr: tr, status: false));
          }

          toastMessage("Liste oluşturuldu");
          listName.clear();
          for (var element in wordTextEditingList) {
            element.clear();
          }
          notifyListeners();
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

      notifyListeners();
    } else {
      toastMessage("En az dört çift gereklidir.");
    }
  }
}