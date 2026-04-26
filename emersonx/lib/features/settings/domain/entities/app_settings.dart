import 'package:flutter/material.dart';

class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.textScaleFactor = 1.0,
    this.showPerformanceOverlay = false,
    this.showGridOverlay = false,
    this.enableDevMode = false,
  });

  final ThemeMode themeMode;
  final double textScaleFactor;
  final bool showPerformanceOverlay;
  final bool showGridOverlay;
  final bool enableDevMode;

  AppSettings copyWith({
    ThemeMode? themeMode,
    double? textScaleFactor,
    bool? showPerformanceOverlay,
    bool? showGridOverlay,
    bool? enableDevMode,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      showPerformanceOverlay: showPerformanceOverlay ?? this.showPerformanceOverlay,
      showGridOverlay: showGridOverlay ?? this.showGridOverlay,
      enableDevMode: enableDevMode ?? this.enableDevMode,
    );
  }
}