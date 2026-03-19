import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF2B6CEE);
  static const Color primaryLight = Color(0xFF4A85F2);
  static const Color primaryDark = Color(0xFF1B4FBF);

  // Backgrounds
  static const Color backgroundDark = Color(0xFF0F1724);
  static const Color surfaceDark = Color(0xFF1A2332);
  static const Color cardDark = Color(0xFF212D3D);
  static const Color cardDarkElevated = Color(0xFF283548);

  static const Color backgroundLight = Color(0xFFF8F9FC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);

  // Text - Dark theme
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFF8B95A5);
  static const Color textTertiaryDark = Color(0xFF5A6577);

  // Text - Light theme
  static const Color textPrimaryLight = Color(0xFF0F1724);
  static const Color textSecondaryLight = Color(0xFF5A6577);
  static const Color textTertiaryLight = Color(0xFF8B95A5);

  // Semantic
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFF4ADE80);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFCA5A5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFCD34D);
  static const Color info = Color(0xFF3B82F6);

  // Accent
  static const Color gold = Color(0xFFD4A853);
  static const Color goldLight = Color(0xFFE8C97A);

  // Border
  static const Color borderDark = Color(0xFF2A3545);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Overlay
  static const Color overlay = Color(0x80000000);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2B6CEE), Color(0xFF1B4FBF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF212D3D), Color(0xFF1A2332)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFD4A853), Color(0xFFE8C97A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
