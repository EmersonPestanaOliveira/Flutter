import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/enums/alerta_tipo.dart';

class AlertPinFactory {
  const AlertPinFactory._();

  static Future<Uint8List> createBytes(AlertaTipo tipo) async {
    const canvasSize = 136.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final center = Offset(canvasSize / 2, canvasSize / 2);

    _drawDiamond(
      canvas: canvas,
      center: center + const Offset(4, 6),
      size: 92,
      radius: 12,
      color: const Color(0x33000000),
    );
    _drawDiamond(
      canvas: canvas,
      center: center,
      size: 96,
      radius: 12,
      color: Colors.white,
    );
    _drawDiamond(
      canvas: canvas,
      center: center,
      size: 80,
      radius: 12,
      color: color(tipo),
    );

    final icon = iconData(tipo);
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );

    final image = await recorder.endRecording().toImage(
      canvasSize.toInt(),
      canvasSize.toInt(),
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData?.buffer.asUint8List();

    if (bytes == null || bytes.isEmpty) {
      throw StateError('Alert pin bytes could not be created.');
    }
    return bytes;
  }

  static double hue(AlertaTipo tipo) {
    return switch (tipo) {
      AlertaTipo.violencia => BitmapDescriptor.hueRed,
      AlertaTipo.rouboFurto ||
      AlertaTipo.rouboFurtoVeiculo => BitmapDescriptor.hueOrange,
      AlertaTipo.acidente => BitmapDescriptor.hueYellow,
      AlertaTipo.estelionato => BitmapDescriptor.hueCyan,
      AlertaTipo.vandalismo => BitmapDescriptor.hueViolet,
      AlertaTipo.invasao => BitmapDescriptor.hueMagenta,
      AlertaTipo.outros => BitmapDescriptor.hueBlue,
    };
  }

  static Color color(AlertaTipo tipo) {
    return switch (tipo) {
      AlertaTipo.violencia => const Color(0xFF0B5DBB),
      AlertaTipo.acidente => const Color(0xFF2E6F9E),
      AlertaTipo.rouboFurtoVeiculo => const Color(0xFFB30012),
      AlertaTipo.rouboFurto => const Color(0xFFE53935),
      AlertaTipo.estelionato => const Color(0xFF006B3F),
      AlertaTipo.vandalismo => const Color(0xFF1E2433),
      AlertaTipo.invasao => const Color(0xFF0B5DBB),
      AlertaTipo.outros => const Color(0xFF7A6A00),
    };
  }

  static IconData iconData(AlertaTipo tipo) {
    return switch (tipo) {
      AlertaTipo.violencia => Icons.gpp_maybe,
      AlertaTipo.acidente => Icons.car_crash,
      AlertaTipo.rouboFurtoVeiculo => Icons.directions_car,
      AlertaTipo.rouboFurto => Icons.shopping_bag,
      AlertaTipo.estelionato => Icons.emergency,
      AlertaTipo.vandalismo => Icons.directions_walk,
      AlertaTipo.invasao => Icons.security,
      AlertaTipo.outros => Icons.warning_amber_rounded,
    };
  }

  static void _drawDiamond({
    required Canvas canvas,
    required Offset center,
    required double size,
    required double radius,
    required Color color,
  }) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(math.pi / 4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: size, height: size),
        Radius.circular(radius),
      ),
      Paint()..color = color,
    );
    canvas.restore();
  }
}
