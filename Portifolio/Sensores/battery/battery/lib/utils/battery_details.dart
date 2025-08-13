import 'dart:io' show Platform;
import 'package:flutter/services.dart';

class BatteryDetails {
  final double? temperatureC; // °C
  final int? voltageMv; // mV
  final int? currentUa; // µA (instantâneo)
  final String? technology; // ex: Li-ion

  const BatteryDetails({
    this.temperatureC,
    this.voltageMv,
    this.currentUa,
    this.technology,
  });
}

class BatteryDetailsService {
  static const _ch = MethodChannel('battery_time_channel');

  static Future<BatteryDetails> fetch() async {
    if (!Platform.isAndroid) return const BatteryDetails();
    final map = await _ch.invokeMapMethod<String, dynamic>('getBatteryStats');
    if (map == null) return const BatteryDetails();

    final int tempTenths = (map['temperature_tenths_c'] ?? -1) as int;
    final int voltageMv = (map['voltage_mV'] ?? -1) as int;
    final int currentUa = (map['current_uA'] ?? 0) as int;
    final String tech = (map['technology'] ?? '') as String;

    return BatteryDetails(
      temperatureC: tempTenths >= 0 ? tempTenths / 10.0 : null,
      voltageMv: voltageMv > 0 ? voltageMv : null,
      currentUa: currentUa != 0 ? currentUa : null,
      technology: tech.isNotEmpty ? tech : null,
    );
  }

  // Helpers de formatação
  static String fmtTemp(double? c) =>
      c == null ? '—' : '${c.toStringAsFixed(1)} °C';
  static String fmtVolt(int? mv) =>
      mv == null ? '—' : '${(mv / 1000).toStringAsFixed(2)} V';
  static String fmtCurr(int? ua) {
    if (ua == null) return '—';
    // mostramo mA com sinal (útil: +carregando, -descarregando em muitos devices)
    final double mA = ua / 1000.0;
    final String sign = mA > 0 ? '+' : '';
    return '$sign${mA.toStringAsFixed(0)} mA';
  }

  static String fmtTech(String? t) => (t == null || t.isEmpty) ? '—' : t;
}
