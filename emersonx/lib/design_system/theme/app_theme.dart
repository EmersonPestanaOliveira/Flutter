import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      surface: AppColors.white,
    ),
    scaffoldBackgroundColor: AppColors.neutral50,
    textTheme: _textTheme(Brightness.light),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.neutral900,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.neutral200),
      ),
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary80,
      surface: AppColors.dark800,
    ),
    scaffoldBackgroundColor: AppColors.dark900,
    textTheme: _textTheme(Brightness.dark),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.dark800,
      foregroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: AppColors.dark700,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.dark600),
      ),
    ),
  );

  static TextTheme _textTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final baseColor = isLight ? AppColors.neutral900 : AppColors.white;
    final mutedColor = isLight ? AppColors.neutral600 : AppColors.neutral400;
    return TextTheme(
      displayLarge:  AppTextStyles.displayLarge.copyWith(color: baseColor),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: baseColor),
      headlineMedium:AppTextStyles.headlineMedium.copyWith(color: baseColor),
      titleLarge:    AppTextStyles.titleLarge.copyWith(color: baseColor),
      titleMedium:   AppTextStyles.titleMedium.copyWith(color: baseColor),
      bodyLarge:     AppTextStyles.bodyLarge.copyWith(color: baseColor),
      bodyMedium:    AppTextStyles.bodyMedium.copyWith(color: mutedColor),
      labelLarge:    AppTextStyles.labelLarge.copyWith(color: baseColor),
      labelSmall:    AppTextStyles.labelSmall.copyWith(color: mutedColor),
    );
  }
}