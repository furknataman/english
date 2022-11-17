import 'dart:math';

import 'package:english/global_variable.dart';
import 'package:flutter/cupertino.dart';

import '../db/db/db.dart';
import '../db/db/shared_preferences.dart';
import '../db/models/words.dart';
import '../global_widget/toast_message.dart';

class MultipleChoice extends ChangeNotifier {
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

  void changeIndex(int index) {
    indexpage = index;
    notifyListeners();
  }

  List<bool> changeLand = [];

  List<Word> words = [];
  bool start = false;

  List<List<String>> optionsList = [];
  List<String> correctAnswers = [];

  List<bool> clickControl = [];
  List<List<bool>> clickControlList = [];

  bool correct = false;
  int correctCount = 0;
  int wrongCount = 0;
  bool learn = false;
  bool unlearn = false;
  int indexpage = 0;
  bool clicked = false;
  void cancel() {
    changeLand = [];
    words = [];
    start = false;
    optionsList = [];
    correctAnswers = [];
    clickControl = [];
    clickControlList = [];
    correct = false;
    correctCount = 0;
    wrongCount = 0;
    learn = false;
    unlearn = false;
    indexpage = 0;
    clicked = false;
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

  void changeunlearn() {
    if (unlearn) {
      unlearn = false;
    } else {
      unlearn = true;
    }
    notifyListeners();
  }

  void checher(index, order, options, correctAnswers) {
    if (clickControl[index] == false) {
      clickControl[index] = true;

      clickControlList[index][order] = true;
      clicked = clickControlList[index][order];

      if (options[order] == correctAnswers) {
        correctCount++;
        correct = true;
      } else {
        wrongCount++;
      }
      if ((correctCount + wrongCount) == words.length) {
        toastMessage("Test Bitti");
      }
    }
    notifyListeners();
  }

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
      if (words.length > 3) {
        if (listMixed) words.shuffle();

        Random random = Random();
        for (int i = 0; i < words.length; i++) {
          clickControl.add(false);

          clickControlList.add([false, false, false, false]);

          List<String> tempOptions = [];
          while (true) {
            int rand = random.nextInt(words.length);
            if (rand != i) {
              bool isThereSame = false;
              for (var element in tempOptions) {
                if (chooeseLang == Lang.eng) {
                  if (element == words[rand].word_tr!) {
                    isThereSame = true;
                  }
                } else {
                  if (element == words[rand].word_eng!) {
                    isThereSame = true;
                  }
                }
              }

              if (!isThereSame) {
                tempOptions.add(chooeseLang == Lang.eng
                    ? words[rand].word_tr!
                    : words[rand].word_eng!);
              }
            }

            if (tempOptions.length == 3) {
              break;
            }
          }
          tempOptions
              .add(chooeseLang == Lang.eng ? words[i].word_tr! : words[i].word_eng!);
          tempOptions.shuffle();
          correctAnswers
              .add(chooeseLang == Lang.eng ? words[i].word_tr! : words[i].word_eng!);
          optionsList.add(tempOptions);
        }

        start = true;
      } else {
        toastMessage("En az 4 kelime gereklidir.");
      }
    } else {
      toastMessage("Seçilen şartlar liste boş.");
    }
    notifyListeners();
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
}