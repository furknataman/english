import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

enum Lang { eng, tr }

Lang? chooeseLang = Lang.eng;

//words_card page and multiple_choice page
enum Which { learned, unlearned, all }

enum ForWhat { fortList, fortListMixed }

enum DarkMode { darkModeOn, darkModeOf }

Which? chooseQuwstionType = Which.learned;
bool listMixed = true;

List<Map<String, Object?>> lists = [];
List<bool> selectedListIndex = [];

String version = "";
int totalWord = 0;
int learnedWord = 0;

final Widget svgLogoIcon = SvgPicture.asset('assets/svg/logo.svg',
colorFilter: const ColorFilter.mode(Color(0xffF3FBF8), BlendMode.srcIn), semanticsLabel: 'A red up arrow');
