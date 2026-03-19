import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// FontAwesome Pro 6.7.2 SVG icons
class AppIcons {
  AppIcons._();

  static const String _base = 'assets/svg';

  // Navigation
  static const String arrowLeft = '$_base/fa_arrow_left.svg';
  static const String chevronLeft = '$_base/fa_chevron_left.svg';
  static const String chevronRight = '$_base/fa_chevron_right.svg';

  // Main cards
  static const String book = '$_base/fa_book.svg';
  static const String creditCard = '$_base/fa_credit_card.svg';
  static const String clockRotateLeft = '$_base/fa_clock_rotate_left.svg';
  static const String plus = '$_base/fa_plus.svg';
  static const String heart = '$_base/fa_heart.svg';

  // Actions
  static const String pen = '$_base/fa_pen.svg';
  static const String trash = '$_base/fa_trash.svg';
  static const String floppyDisk = '$_base/fa_floppy_disk.svg';
  static const String circlePlus = '$_base/fa_circle_plus.svg';
  static const String minus = '$_base/fa_minus.svg';
  static const String list = '$_base/fa_list.svg';

  // Status
  static const String circleCheck = '$_base/fa_circle_check.svg';
  static const String circleXmark = '$_base/fa_circle_xmark.svg';
  static const String xmark = '$_base/fa_xmark.svg';
  static const String circleInfo = '$_base/fa_circle_info.svg';
  static const String gear = '$_base/fa_gear.svg';
  static const String grip = '$_base/fa_grip.svg';

  // Eye
  static const String eye = '$_base/fa_eye.svg';
  static const String eyeSlash = '$_base/fa_eye_slash.svg';

  // Support
  static const String mugHot = '$_base/mug_hot.svg';
  static const String handHoldingHeart = '$_base/hand_holding_heart.svg';
  static const String gift = '$_base/gift.svg';

  /// Render an SVG icon
  static Widget svg(
    String path, {
    double size = 24,
    Color? color,
  }) {
    return SvgPicture.asset(
      path,
      width: size,
      height: size,
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }
}
