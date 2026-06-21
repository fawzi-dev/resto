import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      surface: AppColors.surface,
    ).copyWith(onSurface: AppColors.textDark);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppTypography.fontFamily,
      splashFactory: InkSparkle.splashFactory,
      textTheme: const TextTheme(
        titleLarge: AppTypography.headline,
        titleMedium: AppTypography.sectionTitle,
        bodyMedium: AppTypography.body,
        labelLarge: AppTypography.button,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textDark,
        contentTextStyle: TextStyle(
          fontFamily: AppTypography.fontFamily,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
