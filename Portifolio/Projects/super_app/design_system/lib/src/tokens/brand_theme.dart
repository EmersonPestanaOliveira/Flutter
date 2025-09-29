import 'package:flutter/material.dart';

/// Tokens de cor da marca (ThemeExtension)
/// OBS: mantive `accent` como alias de `secondary` para compatibilidade.
class BrandTheme extends ThemeExtension<BrandTheme> {
  // base
  final Color primary;
  final Color onPrimary;

  // secundária
  final Color secondary;
  final Color onSecondary;

  // alias de compatibilidade (deprecar quando migrar tudo para `secondary`)
  final Color accent;

  // superfícies
  final Color surface;
  final Color onSurface;
  final Color background;
  final Color onBackground;

  // status
  final Color error;
  final Color success;
  final Color warning;
  final Color info;

  // outros tokens do DS
  final BorderRadius radiusMd;
  final double spacingMd;

  const BrandTheme({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.accent, // = secondary
    required this.surface,
    required this.onSurface,
    required this.background,
    required this.onBackground,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
    required this.radiusMd,
    required this.spacingMd,
  });

  @override
  BrandTheme copyWith({
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? accent,
    Color? surface,
    Color? onSurface,
    Color? background,
    Color? onBackground,
    Color? error,
    Color? success,
    Color? warning,
    Color? info,
    BorderRadius? radiusMd,
    double? spacingMd,
  }) {
    return BrandTheme(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      accent: accent ?? (secondary ?? this.accent),
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      radiusMd: radiusMd ?? this.radiusMd,
      spacingMd: spacingMd ?? this.spacingMd,
    );
  }

  @override
  BrandTheme lerp(ThemeExtension<BrandTheme>? other, double t) {
    if (other is! BrandTheme) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return BrandTheme(
      primary: l(primary, other.primary),
      onPrimary: l(onPrimary, other.onPrimary),
      secondary: l(secondary, other.secondary),
      onSecondary: l(onSecondary, other.onSecondary),
      accent: l(accent, other.accent),
      surface: l(surface, other.surface),
      onSurface: l(onSurface, other.onSurface),
      background: l(background, other.background),
      onBackground: l(onBackground, other.onBackground),
      error: l(error, other.error),
      success: l(success, other.success),
      warning: l(warning, other.warning),
      info: l(info, other.info),
      radiusMd: BorderRadius.lerp(radiusMd, other.radiusMd, t)!,
      spacingMd: _lerpDouble(spacingMd, other.spacingMd, t)!,
    );
  }
}

double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
