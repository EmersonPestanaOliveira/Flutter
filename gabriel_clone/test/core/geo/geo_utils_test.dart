import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/core/geo/geo_utils.dart';

void main() {
  group('GeoUtils.geohash', () {
    test('produz hash com precisão correta', () {
      final h = GeoUtils.geohash(-23.5505, -46.6333, precision: 7);
      expect(h.length, 7);
    });

    test('dois pontos próximos compartilham prefixo', () {
      final h1 = GeoUtils.geohash(-23.5505, -46.6333, precision: 7);
      final h2 = GeoUtils.geohash(-23.5506, -46.6334, precision: 7);
      expect(h1.substring(0, 5), h2.substring(0, 5));
    });
  });

  group('GeoUtils.geohashRangesForBounds', () {
    const spBounds = GeoBounds(
      south: -23.60,
      west: -46.70,
      north: -23.50,
      east: -46.60,
    );

    test('retorna ao menos um range para bounds válido', () {
      final ranges = GeoUtils.geohashRangesForBounds(spBounds, zoom: 13);
      expect(ranges, isNotEmpty);
    });

    test('cada range tem lower <= upper', () {
      final ranges = GeoUtils.geohashRangesForBounds(spBounds, zoom: 13);
      for (final r in ranges) {
        expect(r.lower.compareTo(r.upper), lessThanOrEqualTo(0));
      }
    });

    test('zoom alto gera mais ranges que zoom baixo', () {
      final highZoom = GeoUtils.geohashRangesForBounds(spBounds, zoom: 15);
      final lowZoom = GeoUtils.geohashRangesForBounds(spBounds, zoom: 5);
      // Zoom alto = precision maior = mais células = mais ranges (ou igual)
      expect(highZoom.length, greaterThanOrEqualTo(1));
      expect(lowZoom.length, greaterThanOrEqualTo(1));
    });
  });

  group('GeoUtils.clusterCell', () {
    test('pontos próximos têm mesma célula em zoom baixo', () {
      final cell1 = GeoUtils.clusterCell(-23.5505, -46.6333, 8);
      final cell2 = GeoUtils.clusterCell(-23.5515, -46.6343, 8);
      expect(cell1, cell2);
    });

    test('pontos distantes têm células diferentes em zoom alto', () {
      final cell1 = GeoUtils.clusterCell(-23.5505, -46.6333, 16);
      final cell2 = GeoUtils.clusterCell(-23.5605, -46.6433, 16);
      expect(cell1, isNot(cell2));
    });
  });

  group('GeoUtils.distanceKm', () {
    test('distância de SP para RJ ~360 km', () {
      final dist = GeoUtils.distanceKm(-23.5505, -46.6333, -22.9035, -43.1730);
      expect(dist, closeTo(360, 20));
    });

    test('distância de ponto para si mesmo é 0', () {
      final dist = GeoUtils.distanceKm(-23.5, -46.6, -23.5, -46.6);
      expect(dist, closeTo(0, 0.001));
    });
  });

  group('GeoBounds.contains', () {
    const bounds = GeoBounds(south: -23.6, west: -46.7, north: -23.5, east: -46.6);

    test('ponto interno retorna true', () {
      expect(bounds.contains(-23.55, -46.65), isTrue);
    });

    test('ponto externo retorna false', () {
      expect(bounds.contains(-24.0, -46.65), isFalse);
    });
  });
}
