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

final Widget svgLogoIcon = SvgPicture.asset('assets/svg/logo.svg',
    color: const Color(0xffF3FBF8), semanticsLabel: 'A red up arrow');
