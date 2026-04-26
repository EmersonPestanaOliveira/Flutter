import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const fontFamily = 'Roboto';

  static const headingLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const headingMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static const bodyMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const bodySm = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.35,
  );

  static const labelMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const labelSm = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static TextTheme textTheme(Color color) {
    return TextTheme(
      headlineLarge: headingLg.copyWith(color: color),
      headlineMedium: headingMd.copyWith(color: color),
      bodyLarge: bodyMd.copyWith(color: color),
      bodyMedium: bodySm.copyWith(color: color),
      labelLarge: labelMd.copyWith(color: color),
      labelMedium: labelSm.copyWith(color: color),
    );
  }
}