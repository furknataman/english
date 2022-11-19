import 'package:english/db/db/shared_preferences.dart';
import 'package:english/global_variable.dart';
import 'package:flutter/cupertino.dart';

import '../db/db/db.dart';
import '../db/models/words.dart';

class WordCard extends ChangeNotifier {
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

    notifyListeners();
  }

  void changLand(item) {
    if (changeLand[item] == true) {
      changeLand[item] = false;
    } else {
      changeLand[item] = true;
    }
    notifyListeners();
  }

  void changelearn() {
    if (learn) {
      learn = false;
    } else {
      learn = true;
    }
    notifyListeners();
  }

  void cancel() {
    words = [];
    start = false;
    changeLand = [];
    learn = false;
    unlearn = false;
    itemIndex = 0;
    indexpage = 0;
    notifyListeners();
  }

  void changeunlearn() {
    if (unlearn) {
      unlearn = false;
    } else {
      unlearn = true;
    }
    notifyListeners();
  }

  void changeIndex(int index) {
    indexpage = index;
    notifyListeners();
  }

  List<Word> words = [];
  bool start = false;
  List<bool> changeLand = [];
  bool learn = false;
  bool unlearn = false;
  int? itemIndex;
  int indexpage = 0;

  void getSelectedWordOfLists(List<int> selectedListID) async {
    List<String> value = selectedListID.map((e) => e.toString()).toList();
    SP.write("selected_list", value);
    if (learn == true && unlearn != true) {
      words = await DB.instance.readWordByLists(selectedListID, status: true);
    } else if (learn != true && unlearn == true) {
      words = await DB.instance.readWordByLists(selectedListID, status: false);
    } else {
      words = await DB.instance.readWordByLists(
        selectedListID,
      );
    }

    if (words.isNotEmpty) {
      for (int i = 0; i < words.length; i++) {
        changeLand.add(true);
      }
      if (listMixed) words.shuffle();
      start = true;

      notifyListeners();
    }
  }

  void changelearnType() {
    if (words[indexpage].status == true) {
      words[indexpage] = words[indexpage].copy(status: false);
      DB.instance.markAslearned(false, words[indexpage].id as int);
    } else {
      words[indexpage] = words[indexpage].copy(status: true);
      DB.instance.markAslearned(true, words[indexpage].id as int);
    }

    words[indexpage].status;
    notifyListeners();
  }

  List<Color> cardColor = [
    const Color(0xff9B51E0),
    const Color(0xffBB6BD9),
    const Color(0xff56CCF2),
    const Color(0xffF3FBF8),
  ];
}
