import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color(0xFF2ECC71);
  static const Color primaryDark = Color(0xFF27AE60);
  static const Color primarySurface = Color(0xFFEAF9F1);

  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFECEFF1);
  static const Color divider = Color(0xFFF1F3F5);

  static const Color textDark = Color(0xFF2C3E50);
  static const Color textMuted = Color(0xFF7F8C8D);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color danger = Color(0xFFE74C3C);
  static const Color dangerSurface = Color(0xFFFDEDEB);

  static const Color shadow = Color(0x14101828);
  static const Color shimmerBase = Color(0xFFEDF0F2);
  static const Color shimmerHighlight = Color(0xFFF7F9FA);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFF34D67E), primaryDark],
  );
}
