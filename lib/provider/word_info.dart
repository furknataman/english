// ignore_for_file: avoid_print
import 'package:english/db/models/info_state.dart';
import 'package:english/global_variable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final infoProvider = StateProvider<InfoState>((ref) {
  final count = InfoState(totalWord, learnedWord);
  return count;
});



