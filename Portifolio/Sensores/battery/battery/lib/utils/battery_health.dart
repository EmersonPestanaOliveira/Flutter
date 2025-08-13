import 'dart:io' show Platform;
import 'package:flutter/services.dart';

enum BatteryHealthStatus {
  unknown,
  good,
  overheat,
  dead,
  overVoltage,
  cold,
  failure,
}

class BatteryHealth {
  final BatteryHealthStatus status;
  final int rawCode;
  const BatteryHealth(this.status, this.rawCode);
}

class BatteryHealthService {
  static const _ch = MethodChannel('battery_health_channel');

  static Future<BatteryHealth> getHealth() async {
    if (!Platform.isAndroid) {
      return const BatteryHealth(BatteryHealthStatus.unknown, -1);
    }
    final int code = await _ch.invokeMethod<int>('getBatteryHealth') ?? 1;
    return BatteryHealth(_map(code), code);
  }

  static BatteryHealthStatus _map(int code) {
    switch (code) {
      case 2:
        return BatteryHealthStatus.good; // BATTERY_HEALTH_GOOD
      case 3:
        return BatteryHealthStatus.overheat; // BATTERY_HEALTH_OVERHEAT
      case 4:
        return BatteryHealthStatus.dead; // BATTERY_HEALTH_DEAD
      case 5:
        return BatteryHealthStatus.overVoltage; // BATTERY_HEALTH_OVER_VOLTAGE
      case 6:
        return BatteryHealthStatus
            .failure; // BATTERY_HEALTH_UNSPECIFIED_FAILURE
      case 7:
        return BatteryHealthStatus.cold; // BATTERY_HEALTH_COLD
      case 1: // BATTERY_HEALTH_UNKNOWN
      default:
        return BatteryHealthStatus.unknown;
    }
  }

  static String label(BatteryHealthStatus s) {
    switch (s) {
      case BatteryHealthStatus.good:
        return 'Boa';
      case BatteryHealthStatus.overheat:
        return 'Superaquecida';
      case BatteryHealthStatus.dead:
        return 'Danificada (Dead)';
      case BatteryHealthStatus.overVoltage:
        return 'Sobretensão';
      case BatteryHealthStatus.cold:
        return 'Fria';
      case BatteryHealthStatus.failure:
        return 'Falha não especificada';
      case BatteryHealthStatus.unknown:
        return 'Desconhecida';
    }
  }
}
