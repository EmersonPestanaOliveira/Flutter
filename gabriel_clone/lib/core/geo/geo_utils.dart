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

  bool contains(double latitude, double longitude) {
    final inLatitude = latitude >= south && latitude <= north;
    final inLongitude = west <= east
        ? longitude >= west && longitude <= east
        : longitude >= west || longitude <= east;
    return inLatitude && inLongitude;
  }
}

/// Par [lower, upper] de geohash para usar em query Firestore range.
typedef GeoHashRange = ({String lower, String upper});

/// Ponto geográfico simples.
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

  // ---------------------------------------------------------------------------
  // Múltiplos geohash ranges para cobertura de viewport
  // ---------------------------------------------------------------------------

  /// Retorna N×N pontos de amostragem cobrindo o [bounds], em seguida calcula
  /// geohash para cada um e agrupa em ranges [lower, upper] distintos.
  ///
  /// Estratégia: divide o bounds em uma grade de [gridSize]×[gridSize] células,
  /// calcula o geohash de cada canto, remove duplicados e ordena.
  /// Isso garante que um único bounds que cruze múltiplos prefixos de geohash
  /// seja coberto corretamente — o problema da abordagem de apenas dois pontos.
  ///
  /// [precision] determina a granularidade: zoom alto → precision maior (7),
  /// zoom baixo → precision menor (4) para cobrir áreas maiores com menos queries.
  static List<GeoHashRange> geohashRangesForBounds(
    GeoBounds bounds, {
    double zoom = 13,
    int gridSize = 4,
  }) {
    final precision = _precisionForZoom(zoom);
    final latStep = (bounds.north - bounds.south) / gridSize;
    final lonStep = (bounds.east - bounds.west) / gridSize;

    final hashes = <String>{};
    for (var i = 0; i <= gridSize; i++) {
      for (var j = 0; j <= gridSize; j++) {
        final lat = bounds.south + latStep * i;
        final lon = bounds.west + lonStep * j;
        final h = geohash(lat, lon, precision: precision);
        hashes.add(h);
      }
    }

    // Consolida hashes adjacentes em ranges contínuos
    final sorted = hashes.toList()..sort();
    final ranges = <GeoHashRange>[];
    if (sorted.isEmpty) return ranges;

    var rangeStart = sorted.first;
    var rangeEnd = sorted.first;

    for (var i = 1; i < sorted.length; i++) {
      // Se o próximo hash é o próximo caractere ASCII, é adjacente
      if (_isAdjacent(rangeEnd, sorted[i])) {
        rangeEnd = sorted[i];
      } else {
        ranges.add((lower: rangeStart, upper: '${rangeEnd}~'));
        rangeStart = sorted[i];
        rangeEnd = sorted[i];
      }
    }
    ranges.add((lower: rangeStart, upper: '${rangeEnd}~'));

    return ranges;
  }

  static bool _isAdjacent(String a, String b) {
    if (a.length != b.length) return false;
    if (a == b) return true;
    // Prefixo idêntico exceto último char → são adjacentes no mesmo bucket
    return a.substring(0, a.length - 1) == b.substring(0, b.length - 1);
  }

  static int _precisionForZoom(double zoom) {
    if (zoom >= 15) return 7;
    if (zoom >= 13) return 6;
    if (zoom >= 11) return 5;
    if (zoom >= 8) return 4;
    return 3;
  }

  // ---------------------------------------------------------------------------
  // Clustering por geohash (client-side)
  // ---------------------------------------------------------------------------

  /// Retorna a célula (prefixo de geohash) de um ponto para um dado zoom.
  ///
  /// Pontos com mesmo prefixo estão próximos o suficiente para serem agrupados.
  static String clusterCell(double lat, double lon, double zoom) {
    final precision = _clusterPrecisionForZoom(zoom);
    return geohash(lat, lon, precision: precision);
  }

  static int _clusterPrecisionForZoom(double zoom) {
    if (zoom >= 16) return 7; // pins individuais
    if (zoom >= 14) return 6;
    if (zoom >= 12) return 5;
    if (zoom >= 10) return 4;
    if (zoom >= 8) return 3;
    return 2; // clusters grandes
  }
}
