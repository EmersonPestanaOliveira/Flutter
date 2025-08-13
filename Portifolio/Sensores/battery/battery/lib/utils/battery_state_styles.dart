import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

/// Retorna um rótulo, cor e ícone para um [BatteryState].
(String, Color, IconData) styleForBatteryState(BatteryState? state) {
  switch (state) {
    case BatteryState.full:
      return ('Cheia', Colors.green, Icons.battery_full);
    case BatteryState.charging:
      return ('Carregando', Colors.blue, Icons.battery_charging_full);
    case BatteryState.connectedNotCharging:
      return ('Conectado (sem carregar)', Colors.amber, Icons.power);
    case BatteryState.discharging:
      return ('Descarregando', Colors.orange, Icons.battery_std);
    case BatteryState.unknown:
    default:
      return ('Estado desconhecido', Colors.grey, Icons.help_outline);
  }
}
