import 'package:fluttertoast/fluttertoast.dart';
import 'package:english/core/theme/app_colors.dart';

void toastMessage(String message, {int time = 1}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: time,
      backgroundColor: AppColors.cardDarkElevated,
      textColor: AppColors.textPrimaryDark,
      fontSize: 14.0);
}
