import 'package:flutter/material.dart';

/// Paleta de cores do app - tons rose/nude alinhados ao universo
/// de estetica e bem-estar.
class AppColors {
  AppColors._();

  // Primary - rose/nude
  static const Color primary = Color(0xFFD9A79C);
  static const Color primaryDark = Color(0xFF8E5A4E);
  static const Color primaryLight = Color(0xFFF2D9D2);

  // Secondary - verde-oliva calmo
  static const Color secondary = Color(0xFF8A9A7B);
  static const Color secondaryDark = Color(0xFF5D6B50);

  // Accent - dourado discreto (detalhes premium)
  static const Color accent = Color(0xFFC9A96E);

  // Neutros
  static const Color background = Color(0xFFFAF7F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF5F1EC);

  static const Color textPrimary = Color(0xFF2C2A28);
  static const Color textSecondary = Color(0xFF6B6762);
  static const Color textTertiary = Color(0xFFA8A39D);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color border = Color(0xFFE5DFD7);
  static const Color divider = Color(0xFFEDE7DF);

  // Feedback
  static const Color success = Color(0xFF5D8A5A);
  static const Color warning = Color(0xFFD9A44F);
  static const Color error = Color(0xFFC25B5B);
  static const Color info = Color(0xFF5B8AC2);

  // Dark mode (reservado para fase futura)
  static const Color darkBackground = Color(0xFF1A1816);
  static const Color darkSurface = Color(0xFF24211E);
  static const Color darkTextPrimary = Color(0xFFF0EBE4);
  static const Color darkTextSecondary = Color(0xFFB8B0A5);

  // Cores do branding Olenka (extraidas do logo e mockup)
  static const Color brandBlue = Color(0xFF1E3A8A);
  static const Color brandPurple = Color(0xFF7C3A8E);
  static const Color brandPink = Color(0xFFD94A7E);
  static const Color brandPinkLight = Color(0xFFE8A4B8);

  // Gradiente do botao Entrar (roxo -> rosa)
  static const List<Color> primaryGradient = [
    Color(0xFF8E4A9E),
    Color(0xFFD94A7E),
  ];
}
