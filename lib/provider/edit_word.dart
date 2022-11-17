import 'package:flutter/cupertino.dart';

import '../db/db/db.dart';
import '../db/models/words.dart';
import '../global_widget/toast_message.dart';

class EditListWord extends ChangeNotifier {
  List<TextEditingController> wordTextEditingList = [];
  List<Row> wordListField = [];
  List<Word> wordlist = [];
  int dbcount = 0;
  List<bool> selectIndexList = [];
  bool editController = false;

  void editchange() {
    if (editController) {
      editController = false;
    } else {
      editController = true;
    }
    notifyListeners();
  }

  void selectIndexEdit(int i) {
    if (selectIndexList[i]) {
      selectIndexList[i] = false;
    } else {
      selectIndexList[i] = true;
    }
    notifyListeners();
  }

  void getWordByList(listID) async {
    wordTextEditingList = [];
    wordlist = await DB.instance.readWordByList(listID);
    dbcount = wordlist.length;

    for (int i = 0; i < wordlist.length; i++) {
      selectIndexList.add(false);
    }
    for (int i = 0; i < wordlist.length * 2; ++i) {
      wordTextEditingList.add(TextEditingController());
    }
    notifyListeners();
  }

  void learn() async {
    List<int> learnIndexList = [];
    for (int i = 0; i < selectIndexList.length; i++) {
      if (selectIndexList[i] == true) {
        learnIndexList.add(i);
      }
    }
    for (int i = learnIndexList.length - 1; i >= 0; i--) {
      wordlist[learnIndexList[i]] = wordlist[learnIndexList[i]].copy(status: true);
      await DB.instance.markAslearned(true, wordlist[learnIndexList[i]].id as int);
      //print(wordlist[i].word_eng);
    }
    for (int i = 0; i < selectIndexList.length; i++) {
      selectIndexList[i] = false;
    }

    notifyListeners();

    toastMessage("Seçili Kelimeler Öğrenildi olara işaretlendi");
  }

  void unlearn() async {
    List<int> learnIndexList = [];
    for (int i = 0; i < selectIndexList.length; i++) {
      if (selectIndexList[i] == true) {
        learnIndexList.add(i);
      }
    }
    for (int i = learnIndexList.length - 1; i >= 0; i--) {
      wordlist[learnIndexList[i]] = wordlist[learnIndexList[i]].copy(status: false);
      await DB.instance.markAslearned(false, wordlist[learnIndexList[i]].id as int);
      //print(wordlist[i].word_eng);
    }
    for (int i = 0; i < selectIndexList.length; i++) {
      selectIndexList[i] = false;
    }

    notifyListeners();
    toastMessage("Seçili Kelimeler Öğrenilmedi olara işaretlendi");
  }

  void addRow(listID) async {
    wordTextEditingList.add(TextEditingController());
    wordTextEditingList.add(TextEditingController());
    selectIndexList.add(false);
    Word word = (Word(list_id: listID, word_eng: " ", word_tr: "", status: false));
    wordlist.add(word);
    notifyListeners();
  }

  void delete() async {
    List<int> removeIndexLits = [];
    //print(selectIndexList);
    for (int i = 0; i < selectIndexList.length; i++) {
      if (selectIndexList[i] == true) {
        removeIndexLits.add(i);
      }
    }

    for (int i = removeIndexLits.length - 1; i >= 0; i--) {
      wordlist.removeAt(removeIndexLits[i]);
      selectIndexList.removeAt(removeIndexLits[i]);
      wordTextEditingList.length--;
      wordTextEditingList.length--;
    }
    notifyListeners();
    toastMessage(
        "Seçili kelimeler silindi, değişiklikleri kaydetmek için lütfen KAYDET tuşuna basınız.",
        time: 2);
  }

  void save(listID) async {
    bool notEmptyPair = false;
    for (int i = 0; i < wordTextEditingList.length / 2; i++) {
      String eng = wordTextEditingList[2 * i].text;
      String tr = wordTextEditingList[2 * i + 1].text;
      if (eng.isNotEmpty && tr.isNotEmpty) {
      } else {
        notEmptyPair = true;
      }
    }

    if (!notEmptyPair) {
      DB.instance.deleteTableWord(listID!);

      for (int i = 0; i < wordTextEditingList.length / 2; i++) {
        String eng = wordTextEditingList[2 * i].text;
        String tr = wordTextEditingList[2 * i + 1].text;
        bool? status = wordlist[i].status;
        await DB.instance
            .insertWord(Word(list_id: listID, word_eng: eng, word_tr: tr, status: status));
      }

      toastMessage("Kelime listesi güncellendi");
      for (var element in wordTextEditingList) {
        element.clear();
      }
      getWordByList(listID);
    } else {
      toastMessage("Alanlar boş bırakılamaz. Silin veya doldurun.");
    }
  }

  void close() {
    wordTextEditingList = [];
    wordListField = [];
    wordlist = [];
    dbcount = 0;
    selectIndexList = [];
    editController = false;
    notifyListeners();
  }

  void deleteRow() {
    if (wordListField.length > wordlist.length) {
      wordListField;
      notifyListeners();
    } else {
      toastMessage("Kayıtlı Kelimeleri silmek için lütfen menüyü kullanın");
    }
  }
}