import '../../../../core/geo/geo_utils.dart';
import '../entities/alerta.dart';
import '../entities/alerta_cluster.dart';

/// Serviço de clustering client-side baseado em geohash.
///
/// Estratégia:
/// 1. Para cada alerta, calcula a célula geohash baseada no zoom atual.
/// 2. Agrupa alertas com mesma célula.
/// 3. Calcula o centróide de cada grupo.
/// 4. Retorna a lista de [AlertaCluster].
///
/// Complexidade: O(n) — linear no número de alertas.
///
/// Vantagens sobre clustering de terceiros:
/// - Sem dependência externa.
/// - Determinístico: mesma entrada → mesma saída (testável).
/// - Integra-se nativamente com o [GeoUtils.clusterCell].
/// - Funciona offline.
///
/// Quando migrar para backend clustering (PostGIS/Supercluster):
/// - Manter esta interface pública.
/// - Substituir a implementação sem alterar a UI.
abstract final class AlertaClusterService {
  /// Agrupa [alertas] em clusters para o [zoom] atual.
  ///
  /// [minClusterSize] — número mínimo de alertas para formar um cluster.
  /// Abaixo deste valor, cada alerta é retornado como cluster individual.
  static List<AlertaCluster> cluster(
    List<Alerta> alertas,
    double zoom, {
    int minClusterSize = 2,
  }) {
    if (alertas.isEmpty) return const [];

    // 1. Agrupa por célula geohash
    final cells = <String, List<Alerta>>{};
    for (final alerta in alertas) {
      final cell = GeoUtils.clusterCell(alerta.latitude, alerta.longitude, zoom);
      cells.putIfAbsent(cell, () => []).add(alerta);
    }

    // 2. Constrói clusters
    final clusters = <AlertaCluster>[];
    for (final entry in cells.entries) {
      final cell = entry.key;
      final group = entry.value;

      if (group.length < minClusterSize) {
        // Pins individuais — não agrupa
        for (final alerta in group) {
          clusters.add(
            AlertaCluster(
              id: 'pin_${alerta.id}',
              centerLatitude: alerta.latitude,
              centerLongitude: alerta.longitude,
              alertas: [alerta],
              cellKey: cell,
            ),
          );
        }
        continue;
      }

      // Calcula centróide (média aritmética)
      final avgLat = group.map((a) => a.latitude).reduce((a, b) => a + b) /
          group.length;
      final avgLon =
          group.map((a) => a.longitude).reduce((a, b) => a + b) / group.length;

      clusters.add(
        AlertaCluster(
          id: 'cluster_$cell',
          centerLatitude: avgLat,
          centerLongitude: avgLon,
          alertas: group,
          cellKey: cell,
        ),
      );
    }

    return clusters;
  }
}
