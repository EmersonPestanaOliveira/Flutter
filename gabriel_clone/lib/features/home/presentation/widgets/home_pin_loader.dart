import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/enums/alerta_tipo.dart';
import 'alert_pin_factory.dart';

abstract final class HomePinLoader {
  static const cameraAsset = 'assets/images/camera_chameleon_pin.png';

  static Future<BitmapDescriptor?> cameraPin() async {
    try {
      return await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(22, 22)),
        cameraAsset,
        width: 22,
        height: 22,
      );
    } catch (_) {
      return null;
    }
  }

  static Future<Map<AlertaTipo, BitmapDescriptor>> alertPins() async {
    final icons = <AlertaTipo, BitmapDescriptor>{};
    for (final tipo in AlertaTipo.values) {
      final bytes = await AlertPinFactory.createBytes(tipo);
      // ignore: deprecated_member_use
      icons[tipo] = BitmapDescriptor.fromBytes(bytes);
    }
    return icons;
  }
}
