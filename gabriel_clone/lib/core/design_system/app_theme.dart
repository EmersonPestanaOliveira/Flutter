import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        colorScheme: const ColorScheme.light(
          primary: AppColors.headerBlue,
          onPrimary: AppColors.neutral0,
          secondary: AppColors.accentRed,
          onSecondary: AppColors.neutral0,
          surface: AppColors.neutral50,
          onSurface: AppColors.neutral900,
          error: AppColors.error,
          onError: AppColors.neutral0,
        ),
        scaffoldBackgroundColor: AppColors.neutral50,
        textTheme: AppTypography.textTheme(AppColors.neutral900),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.headerBlue,
          foregroundColor: AppColors.neutral0,
          centerTitle: false,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.accentRed,
            foregroundColor: AppColors.neutral0,
            textStyle: AppTypography.labelMd,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.headerBlue,
            textStyle: AppTypography.labelMd,
          ),
        ),
        useMaterial3: true,
      );

  static ThemeData get dark => ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: AppColors.headerBlue,
          onPrimary: AppColors.neutral0,
          secondary: AppColors.accentRed,
          onSecondary: AppColors.neutral0,
          surface: AppColors.neutral900,
          onSurface: AppColors.neutral50,
          error: AppColors.error,
          onError: AppColors.neutral0,
        ),
        scaffoldBackgroundColor: AppColors.neutral900,
        textTheme: AppTypography.textTheme(AppColors.neutral50),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.headerBlue,
          foregroundColor: AppColors.neutral0,
          centerTitle: false,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.accentRed,
            foregroundColor: AppColors.neutral0,
            textStyle: AppTypography.labelMd,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.neutral50,
            textStyle: AppTypography.labelMd,
          ),
        ),
        useMaterial3: true,
      );
}