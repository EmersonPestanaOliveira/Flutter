import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/app_settings.dart';

class SettingsCubit extends Cubit<AppSettings> {
  SettingsCubit() : super(const AppSettings());

  void setTheme(ThemeMode mode) => emit(state.copyWith(themeMode: mode));

  void setTextScale(double scale) {
    final clamped = scale.clamp(0.8, 1.4);
    emit(state.copyWith(textScaleFactor: clamped));
  }

  void togglePerformanceOverlay() => emit(
    state.copyWith(showPerformanceOverlay: !state.showPerformanceOverlay),
  );

  void toggleGridOverlay() => emit(
    state.copyWith(showGridOverlay: !state.showGridOverlay),
  );

  void toggleDevMode() => emit(
    state.copyWith(enableDevMode: !state.enableDevMode),
  );

  void reset() => emit(const AppSettings());
}