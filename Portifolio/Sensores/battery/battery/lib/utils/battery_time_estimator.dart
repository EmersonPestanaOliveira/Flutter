import 'dart:io' show Platform;
import 'package:flutter/services.dart';

class BatteryTimeEstimation {
  final Duration? toEmpty; // se descarregando
  final Duration? toFull; // se carregando
  final bool? isCharging;
  const BatteryTimeEstimation({this.toEmpty, this.toFull, this.isCharging});
}

class BatteryTimeEstimator {
  static const _ch = MethodChannel('battery_time_channel');

  /// Retorna estimativas *aproximadas*. Pode vir nulo se o dispositivo não expõe dados.
  static Future<BatteryTimeEstimation> estimate({int? levelPercent}) async {
    if (!Platform.isAndroid) return const BatteryTimeEstimation();

    final map = await _ch.invokeMapMethod<String, dynamic>('getBatteryStats');
    if (map == null) return const BatteryTimeEstimation();

    final int chargeUAH = (map['charge_uAh'] ?? -1) as int;
    int currentUA = (map['current_uA'] ?? 0) as int;
    final int status = (map['status'] ?? -1) as int;
    final int percent = levelPercent ?? (map['percent'] ?? -1) as int;

    if (chargeUAH <= 0 || currentUA == 0 || percent <= 0) {
      return const BatteryTimeEstimation();
    }

    // Em muitos devices: corrente positiva quando CARREGANDO, negativa quando DESCARREGANDO.
    // Mas há variações; vamos inferir pelo status se disponível.
    final bool charging =
        status == 2 /*BATTERY_STATUS_CHARGING*/ ||
        status == 5 /*FULL*/ ||
        currentUA > 0;

    // µAh / µA = horas
    Duration? toEmpty;
    Duration? toFull;

    if (!charging) {
      final double hours = chargeUAH.abs() / currentUA.abs();
      toEmpty = _hoursToDuration(hours);
    } else {
      // Estima capacidade total: cap ≈ charge / (level/100)
      final double level = percent.clamp(1, 100) / 100.0;
      final double fullUAH = chargeUAH / level;
      final double remainingUAH = (fullUAH - chargeUAH).clamp(
        0,
        double.infinity,
      );
      if (currentUA > 0) {
        final double hours = remainingUAH / currentUA;
        toFull = _hoursToDuration(hours);
      }
    }

    return BatteryTimeEstimation(
      toEmpty: toEmpty,
      toFull: toFull,
      isCharging: charging,
    );
  }

  static Duration _hoursToDuration(double h) {
    final totalMinutes = (h * 60).clamp(0, 1e9).round();
    return Duration(minutes: totalMinutes);
  }

  static String pretty(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h <= 0) return '$m min';
    return '${h}h ${m.toString().padLeft(2, '0')}m';
  }
}
