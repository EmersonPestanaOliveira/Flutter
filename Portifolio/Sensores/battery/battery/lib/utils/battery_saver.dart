import 'dart:io' show Platform;
import 'package:flutter/services.dart';

class BatterySaver {
  static const _ch = MethodChannel('battery_saver_channel');

  static Future<void> openSettings() async {
    if (!Platform.isAndroid) return;
    try {
      await _ch.invokeMethod('openBatterySaver');
    } on PlatformException {
      // opcional: tratar/mostrar snackbar
    }
  }
}
