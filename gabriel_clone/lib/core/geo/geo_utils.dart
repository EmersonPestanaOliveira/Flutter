import 'dart:math' as math;

class GeoBounds {
  const GeoBounds({
    required this.south,
    required this.west,
    required this.north,
    required this.east,
  });

  final double south;
  final double west;
  final double north;
  final double east;

  bool get crossesAntimeridian => west > east;

  bool contains(double latitude, double longitude) {
    final inLatitude = latitude >= south && latitude <= north;
    final inLongitude = crossesAntimeridian
        ? longitude >= west || longitude <= east
        : longitude >= west && longitude <= east;
    return inLatitude && inLongitude;
  }
}

/// Par [lower, upper] de geohash para usar em query Firestore range.
typedef GeoHashRange = ({String lower, String upper});

/// Ponto geografico simples.
typedef GeoPoint2 = ({double lat, double lon});

abstract final class GeoUtils {
  static const _base32 = '0123456789bcdefghjkmnpqrstuvwxyz';

  static String geohash(
    double latitude,
    double longitude, {
    int precision = 7,
  }) {
    var latRange = [-90.0, 90.0];
    var lonRange = [-180.0, 180.0];
    var isEven = true;
    var bit = 0;
    var ch = 0;
    final hash = StringBuffer();

    while (hash.length < precision) {
      if (isEven) {
        final mid = (lonRange[0] + lonRange[1]) / 2;
        if (longitude >= mid) {
          ch |= 1 << (4 - bit);
          lonRange[0] = mid;
        } else {
          lonRange[1] = mid;
        }
      } else {
        final mid = (latRange[0] + latRange[1]) / 2;
        if (latitude >= mid) {
          ch |= 1 << (4 - bit);
          latRange[0] = mid;
        } else {
          latRange[1] = mid;
        }
      }

      isEven = !isEven;
      if (bit < 4) {
        bit++;
      } else {
        hash.write(_base32[ch]);
        bit = 0;
        ch = 0;
      }
    }

    return hash.toString();
  }

  static double distanceKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadiusKm = 6371.0;
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  static double _toRadians(double degrees) => degrees * math.pi / 180;

  /// Retorna ranges de geohash que cobrem todo o [bounds].
  ///
  /// A precisao alvo vem do zoom, mas e reduzida quando a area geraria queries
  /// demais. Isso preserva cobertura completa do viewport e troca precisao por
  /// over-fetch controlado, com filtro defensivo depois da query.
  static List<GeoHashRange> geohashRangesForBounds(
    GeoBounds bounds, {
    double zoom = 13,
    int maxRanges = 48,
  }) {
    final targetPrecision = _precisionForZoom(zoom);
    final maxHashesPerAttempt = math.max(maxRanges * 32, maxRanges);
    for (var precision = targetPrecision; precision >= 1; precision--) {
      if (_estimatedCoveringHashCount(bounds, precision) >
          maxHashesPerAttempt) {
        continue;
      }
      final hashes = _coveringHashes(bounds, precision: precision);
      final ranges = _rangesFromHashes(hashes);
      if (ranges.length <= maxRanges || precision == 1) {
        return ranges;
      }
    }

    return const [];
  }

  static int _estimatedCoveringHashCount(GeoBounds bounds, int precision) {
    final normalized = _normalizeBounds(bounds);
    final cell = _cellSizeForPrecision(precision);
    final latCount =
        ((normalized.north - normalized.south).abs() / cell.height).ceil() + 2;
    final lonSpan = normalized.crossesAntimeridian
        ? (180 - normalized.west) + (normalized.east + 180)
        : (normalized.east - normalized.west).abs();
    final lonCount = (lonSpan / cell.width).ceil() + 2;
    return latCount * lonCount;
  }

  static Set<String> _coveringHashes(
    GeoBounds bounds, {
    required int precision,
  }) {
    final normalized = _normalizeBounds(bounds);
    final parts = normalized.crossesAntimeridian
        ? [
            GeoBounds(
              south: normalized.south,
              west: normalized.west,
              north: normalized.north,
              east: 180,
            ),
            GeoBounds(
              south: normalized.south,
              west: -180,
              north: normalized.north,
              east: normalized.east,
            ),
          ]
        : [normalized];

    final hashes = <String>{};
    final cell = _cellSizeForPrecision(precision);
    for (final part in parts) {
      final latStart = _alignedCellStart(part.south, -90, cell.height);
      final lonStart = _alignedCellStart(part.west, -180, cell.width);

      for (var lat = latStart; lat <= part.north; lat += cell.height) {
        final sampleLat = (lat + cell.height / 2).clamp(-90.0, 90.0);
        for (var lon = lonStart; lon <= part.east; lon += cell.width) {
          final sampleLon = (lon + cell.width / 2).clamp(-180.0, 180.0);
          hashes.add(geohash(sampleLat, sampleLon, precision: precision));
        }
      }
    }
    return hashes;
  }

  static GeoBounds _normalizeBounds(GeoBounds bounds) {
    return GeoBounds(
      south: math.min(bounds.south, bounds.north).clamp(-90.0, 90.0),
      west: bounds.west.clamp(-180.0, 180.0),
      north: math.max(bounds.south, bounds.north).clamp(-90.0, 90.0),
      east: bounds.east.clamp(-180.0, 180.0),
    );
  }

  static double _alignedCellStart(
    double value,
    double origin,
    double cellSize,
  ) {
    return origin + ((value - origin) / cellSize).floor() * cellSize;
  }

  static ({double height, double width}) _cellSizeForPrecision(int precision) {
    final bits = precision * 5;
    final lonBits = (bits + 1) ~/ 2;
    final latBits = bits ~/ 2;
    return (
      height: 180 / math.pow(2, latBits),
      width: 360 / math.pow(2, lonBits),
    );
  }

  static List<GeoHashRange> _rangesFromHashes(Set<String> hashes) {
    final sorted = hashes.toList()..sort();
    final ranges = <GeoHashRange>[];
    if (sorted.isEmpty) return ranges;

    var rangeStart = sorted.first;
    var rangeEnd = sorted.first;

    for (var i = 1; i < sorted.length; i++) {
      if (_isAdjacent(rangeEnd, sorted[i])) {
        rangeEnd = sorted[i];
      } else {
        ranges.add((lower: rangeStart, upper: '$rangeEnd~'));
        rangeStart = sorted[i];
        rangeEnd = sorted[i];
      }
    }
    ranges.add((lower: rangeStart, upper: '$rangeEnd~'));

    return ranges;
  }

  static bool _isAdjacent(String a, String b) {
    if (a.length != b.length) return false;
    if (a == b) return true;
    return a.substring(0, a.length - 1) == b.substring(0, b.length - 1);
  }

  static int _precisionForZoom(double zoom) {
    if (zoom >= 15) return 7;
    if (zoom >= 13) return 6;
    if (zoom >= 11) return 5;
    if (zoom >= 8) return 4;
    return 3;
  }

  /// Retorna a celula (prefixo de geohash) de um ponto para um dado zoom.
  static String clusterCell(double lat, double lon, double zoom) {
    final precision = _clusterPrecisionForZoom(zoom);
    return geohash(lat, lon, precision: precision);
  }

  static int _clusterPrecisionForZoom(double zoom) {
    if (zoom >= 16) return 7;
    if (zoom >= 14) return 6;
    if (zoom >= 12) return 5;
    if (zoom >= 10) return 4;
    if (zoom >= 8) return 3;
    return 2;
  }
}
