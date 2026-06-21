import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static const String fontFamily = 'Vazirmatn';

  static const TextStyle headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 19,
    height: 1.3,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    height: 1.3,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.5,
    height: 1.35,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.5,
    height: 1.2,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle price = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.5,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDark,
  );

  static const TextStyle chip = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.5,
    height: 1.2,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle hint = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 1.3,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );
}
