import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

ThemeData buildAcmeTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  const primary = Color(0xFF0A84FF); // azul ACME
  const secondary = Color(0xFF5AC8FA); // ciano
  final surface = isDark ? const Color(0xFF121212) : Colors.white;
  final onSurface = isDark ? Colors.white : const Color(0xFF111318);
  final background = isDark ? const Color(0xFF0B0B0C) : const Color(0xFFF7F9FC);
  final onBackground = isDark ? Colors.white : const Color(0xFF111318);

  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorSchemeSeed: primary,
  );

  final brand = BrandTheme(
    primary: primary,
    onPrimary: Colors.white,
    secondary: secondary,
    onSecondary: Colors.black,
    accent: secondary, // alias
    surface: surface,
    onSurface: onSurface,
    background: background,
    onBackground: onBackground,
    error: const Color(0xFFDC3545),
    success: const Color(0xFF34C759),
    warning: const Color(0xFFFFD60A),
    info: const Color(0xFF64D2FF),
    radiusMd: BorderRadius.circular(16),
    spacingMd: 12,
  );

  return base.copyWith(
    extensions: [brand],
    appBarTheme:
        AppBarTheme(backgroundColor: surface, foregroundColor: onSurface),
  );
}
