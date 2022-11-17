// ignore_for_file: avoid_print
import 'package:flutter/cupertino.dart';

import '../db/db/db.dart';

class InfoProvider extends ChangeNotifier {
  int totalWord = 0;
  int learnedWord = 0;
  void getCounter() async {
    totalWord = await DB.instance.getCount();
    learnedWord = await DB.instance.getLearnCount();
    notifyListeners();
  }
}
