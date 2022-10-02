import 'package:flutter/material.dart';

import 'db.dart';

class Counter extends ChangeNotifier {
  void getWord() async {
    int totalWord = await DB.instance.getCount();
    notifyListeners();
  }

  void getLearn() async {
    int learnedWord = await DB.instance.getLearnCount();
    notifyListeners();
  }
}
