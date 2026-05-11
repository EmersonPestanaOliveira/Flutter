import 'dart:math' as math;

import '../entities/alerta.dart';
import '../enums/alerta_tipo.dart';

class StressPinsGenerator {
  const StressPinsGenerator();

  static const defaultSeed = 424242;

  /// Bounds aproximado do municipio de Sao Paulo.
  ///
  /// A distribuicao usa amostras pseudo-aleatorias deterministicas para que
  /// duas execucoes com o mesmo count/seed gerem os mesmos pins.
  List<Alerta> generateSaoPauloPins({
    required int count,
    int seed = defaultSeed,
  }) {
    if (count <= 0) return const [];

    final random = math.Random(seed);
    final baseDate = DateTime(2026, 5, 1);
    return List<Alerta>.generate(count, (index) {
      final position = _randomSaoPauloPosition(random);
      final tipo = AlertaTipo.values[index % AlertaTipo.values.length];
      final neighborhood = _neighborhoodFor(position.latitude, position.longitude);

      return Alerta(
        id: 'stress-sp-$index',
        bairro: neighborhood,
        cidade: 'Sao Paulo',
        data: baseDate.add(Duration(minutes: index % (30 * 24 * 60))),
        descricao: 'Pin sintetico de stress #$index',
        tipo: tipo,
        latitude: position.latitude,
        longitude: position.longitude,
      );
    }, growable: false);
  }

  ({double latitude, double longitude}) _randomSaoPauloPosition(
    math.Random random,
  ) {
    // Bounding box aproximado de Sao Paulo: norte/sul/leste/oeste.
    const south = -24.008;
    const north = -23.357;
    const west = -46.826;
    const east = -46.365;

    final latitude = south + random.nextDouble() * (north - south);
    final longitude = west + random.nextDouble() * (east - west);
    return (latitude: latitude, longitude: longitude);
  }

  String _neighborhoodFor(double latitude, double longitude) {
    if (latitude > -23.48) return 'Zona Norte';
    if (latitude < -23.75) return 'Zona Sul';
    if (longitude < -46.70) return 'Zona Oeste';
    if (longitude > -46.50) return 'Zona Leste';
    return 'Centro Expandido';
  }
}
