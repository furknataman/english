import 'db/db/db.dart';
import 'db/db/sharedPreferences.dart';

enum Lang { eng, tr }

Lang? chooeseLang = Lang.eng;

//words_card page and multiple_choice page
enum Which { learned, unlearned, all }

enum ForWhat { fortList, fortListMixed }

Which? chooseQuwstionType = Which.learned;
bool listMixed = true;

List<Map<String, Object?>> lists = [];
List<bool> selectedListIndex = [];

