import 'package:english/global_variable.dart';
import '../models/lists.dart';
import '../models/words.dart';
import 'package:english/db/db/sharedPreferences.dart';
import 'db.dart';

void defaultWord() async {
  if (await SP.read("default") != false) {
    Lists addedList = await DB.instance.insertList(const Lists(name: "Temel Kelimeler-1"));
    List<String> eng = ["After", "Again", "All", "Another", "Answer"];
    List<String> tr = ["Sonra", "Tekrar", "Hepsi", "Başka", "Cevap"];

    for (int i = 0; i < eng.length; i++) {
      await DB.instance.insertWord(
          Word(list_id: addedList.id, word_eng: eng[i], word_tr: tr[i], status: false));
    }

    Lists addedList2 =
        await DB.instance.insertList(const Lists(name: "Temel Kelimeler-2"));
    List<String> eng2 = ["Ask", "Be", "Before", "Begin", "But", "Buy", "Change"];
    List<String> tr2 = [
      "Sormak",
      "Olmak",
      "Önce",
      "Başlamak",
      "Ama",
      "Satın Almak",
      "Değişim"
    ];
    for (int i = 0; i < eng2.length; i++) {
      await DB.instance.insertWord(
          Word(list_id: addedList2.id, word_eng: eng2[i], word_tr: tr2[i], status: false));
    }

    Lists addedList3 =
        await DB.instance.insertList(const Lists(name: "Temel Kelimeler-3"));
    List<String> eng3 = ["Clean", "Come", "Game", "Easy", "Eat", "Feel", "Find", "Forget"];
    List<String> tr3 = [
      "Temiz",
      "Gelmek",
      "Oyun",
      "Kolay",
      "Yemek",
      "Hissetmek",
      "Bulmak",
      "Unutmak"
    ];
    for (int i = 0; i < eng3.length; i++) {
      await DB.instance.insertWord(
          Word(list_id: addedList3.id, word_eng: eng3[i], word_tr: tr3[i], status: false));
    }
    /*int x = await DB.instance.getCount();
    int y = await DB.instance.getLearnCount();
    print("Toplam Kelime $x , Öğrenilen kelime $y ");
*/
    SP.write("default", false);
  }
}


void getCounter() async {
   totalWord = await DB.instance.getCount();
   learnedWord = await DB.instance.getLearnCount();
}
