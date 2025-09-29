import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

ThemeData buildBetaTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  const primary = Color(0xFF6D28D9); // roxo
  const secondary = Color(0xFFF59E0B); // amber
  final surface = isDark ? const Color(0xFF121212) : Colors.white;
  final onSurface = isDark ? Colors.white : const Color(0xFF111318);
  final background = isDark ? const Color(0xFF0B0B0C) : const Color(0xFFF8F6FF);
  final onBackground = isDark ? Colors.white : const Color(0xFF0F1020);

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
    error: const Color(0xFFEF4444),
    success: const Color(0xFF10B981),
    warning: const Color(0xFFF59E0B),
    info: const Color(0xFF60A5FA),
    radiusMd: BorderRadius.circular(12),
    spacingMd: 10,
  );

  return base.copyWith(
    extensions: [brand],
    appBarTheme:
        AppBarTheme(backgroundColor: surface, foregroundColor: onSurface),
  );
}
