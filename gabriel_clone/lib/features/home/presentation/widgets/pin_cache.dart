import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/enums/alerta_tipo.dart';

/// Cache estático de [BitmapDescriptor] para pins individuais e clusters.
///
/// Chaves:
/// - Pin individual: `'pin_${tipo.name}'`
/// - Cluster      : `'cluster_${bucket}'` onde bucket ∈ {1, 10, 50, 100, 500}
abstract final class PinCache {
  static final Map<String, BitmapDescriptor> _cache = {};

  // ---------------------------------------------------------------------------
  // Pins individuais (AlertaTipo)
  // ---------------------------------------------------------------------------

  /// Retorna o [BitmapDescriptor] cacheado para o tipo, ou null se ainda não
  /// foi gerado (geração lazy via [HomePinLoader.alertPins] no init do mapa).
  static BitmapDescriptor? alertPin(AlertaTipo tipo) {
    return _cache['pin_${tipo.name}'];
  }

  /// Armazena todos os pins de alerta carregados de uma vez.
  static void storeAlertPins(Map<AlertaTipo, BitmapDescriptor> pins) {
    for (final entry in pins.entries) {
      _cache['pin_${entry.key.name}'] = entry.value;
    }
  }

  // ---------------------------------------------------------------------------
  // Cluster pins (geração dinâmica com canvas)
  // ---------------------------------------------------------------------------

  /// Bucket de tamanho para o cache: normaliza a contagem em um dos 5 limites.
  static int sizeBucket(int count) {
    if (count >= 500) return 500;
    if (count >= 100) return 100;
    if (count >= 50) return 50;
    if (count >= 10) return 10;
    return 1;
  }

  /// Retorna o cluster [BitmapDescriptor] do cache ou gera e armazena.
  static Future<BitmapDescriptor> clusterPin(int count) async {
    final bucket = sizeBucket(count);
    final key = 'cluster_$bucket';
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }
    final descriptor = await _buildClusterBitmap(bucket);
    _cache[key] = descriptor;
    return descriptor;
  }

  // ---------------------------------------------------------------------------
  // Geração do bitmap de cluster
  // ---------------------------------------------------------------------------

  static Future<BitmapDescriptor> _buildClusterBitmap(int bucket) async {
    final size = _canvasSize(bucket);
    final radius = size / 2;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final center = Offset(radius, radius);

    // Sombra
    canvas.drawCircle(
      center + const Offset(3, 5),
      radius * 0.85,
      Paint()..color = const Color(0x33000000),
    );

    // Anel externo branco
    canvas.drawCircle(center, radius, Paint()..color = Colors.white);

    // Círculo colorido interno
    canvas.drawCircle(
      center,
      radius * 0.78,
      Paint()..color = _clusterColor(bucket),
    );

    // Texto com a contagem
    final label = bucket >= 500 ? '500+' : '$bucket+';
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.48,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );

    final image = await recorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();
    // ignore: deprecated_member_use
    return BitmapDescriptor.fromBytes(bytes);
  }

  static double _canvasSize(int bucket) {
    return switch (bucket) {
      >= 500 => 140.0,
      >= 100 => 122.0,
      >= 50 => 108.0,
      >= 10 => 96.0,
      _ => 84.0,
    };
  }

  static Color _clusterColor(int bucket) {
    return switch (bucket) {
      >= 500 => const Color(0xFF7B1FA2), // roxo
      >= 100 => const Color(0xFFB71C1C), // vermelho escuro
      >= 50 => const Color(0xFFE53935), // vermelho
      >= 10 => const Color(0xFFF57C00), // laranja
      _ => const Color(0xFF27AE60), // verde (grupo pequeno)
    };
  }

  /// Limpa o cache (útil em testes).
  static void clear() => _cache.clear();
}

// Importação circular evitada — AlertPinFactory é separado
// ignore: unused_import
extension _Unused on math.Random {}
