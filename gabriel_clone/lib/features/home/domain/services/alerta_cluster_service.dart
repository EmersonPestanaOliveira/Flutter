import 'dart:math' as math;

import '../../../../core/geo/geo_utils.dart';
import '../entities/alerta.dart';
import '../entities/alerta_cluster.dart';

class ClusterPolicy {
  const ClusterPolicy({
    this.minPinsToEnableClustering = 501,
    this.minClusterSize = 3,
    this.maxZoomForClustering = 15.5,
    this.highDensityClusterSize = 8,
    this.forceIndividualPinsWhenBelowThreshold = true,
  });

  final int minPinsToEnableClustering;
  final int minClusterSize;
  final double maxZoomForClustering;
  final int highDensityClusterSize;
  final bool forceIndividualPinsWhenBelowThreshold;
}

class AlertaClusterResult {
  const AlertaClusterResult({
    required this.clusters,
    required this.enabled,
    required this.reason,
    required this.elapsedMs,
  });

  final List<AlertaCluster> clusters;
  final bool enabled;
  final String reason;
  final int elapsedMs;

  int get clusterCount => clusters.where((cluster) => cluster.isCluster).length;
  int get individualPinCount =>
      clusters.fold(0, (sum, cluster) => sum + (cluster.isCluster ? 0 : 1));
}

abstract final class ClusterDecisionReasons {
  static const belowPinThreshold = 'below_pin_threshold';
  static const zoomTooHigh = 'zoom_too_high';
  static const densityTooLow = 'density_too_low';
  static const enabledHighDensity = 'enabled_high_density';
  static const enabledHighVolume = 'enabled_high_volume';
}

abstract final class AlertaClusterService {
  static const defaultPolicy = ClusterPolicy();

  static List<AlertaCluster> cluster(
    List<Alerta> alertas,
    double zoom, {
    int minClusterSize = 3,
  }) {
    return build(
      alertas,
      zoom,
      policy: ClusterPolicy(minClusterSize: minClusterSize),
    ).clusters;
  }

  static AlertaClusterResult build(
    List<Alerta> alertas,
    double zoom, {
    ClusterPolicy policy = defaultPolicy,
  }) {
    final start = DateTime.now().millisecondsSinceEpoch;
    if (alertas.isEmpty) {
      return AlertaClusterResult(
        clusters: const [],
        enabled: false,
        reason: ClusterDecisionReasons.belowPinThreshold,
        elapsedMs: DateTime.now().millisecondsSinceEpoch - start,
      );
    }

    if (zoom > policy.maxZoomForClustering) {
      return AlertaClusterResult(
        clusters: _buildIndividualPins(alertas, zoom),
        enabled: false,
        reason: ClusterDecisionReasons.zoomTooHigh,
        elapsedMs: DateTime.now().millisecondsSinceEpoch - start,
      );
    }

    final cells = _groupByCell(alertas, zoom);
    final largestGroup = cells.values.fold<int>(
      0,
      (max, group) => math.max(max, group.length),
    );
    final reason = _decisionReason(
      alertas.length,
      largestGroup,
      zoom,
      policy,
    );
    final enabled = reason == ClusterDecisionReasons.enabledHighDensity ||
        reason == ClusterDecisionReasons.enabledHighVolume;

    final clusters = enabled
        ? _buildClusters(cells, policy.minClusterSize)
        : _buildIndividualPins(alertas, zoom);

    return AlertaClusterResult(
      clusters: clusters,
      enabled: enabled,
      reason: reason,
      elapsedMs: DateTime.now().millisecondsSinceEpoch - start,
    );
  }

  static String _decisionReason(
    int pinCount,
    int largestGroup,
    double zoom,
    ClusterPolicy policy,
  ) {
    if (pinCount >= policy.minPinsToEnableClustering &&
        largestGroup >= policy.minClusterSize) {
      return ClusterDecisionReasons.enabledHighVolume;
    }
    if (pinCount >= policy.minPinsToEnableClustering &&
        largestGroup >= policy.highDensityClusterSize) {
      return ClusterDecisionReasons.enabledHighDensity;
    }
    if (pinCount < policy.minPinsToEnableClustering &&
        policy.forceIndividualPinsWhenBelowThreshold) {
      return ClusterDecisionReasons.belowPinThreshold;
    }
    return ClusterDecisionReasons.densityTooLow;
  }

  static Map<String, List<Alerta>> _groupByCell(List<Alerta> alertas, double zoom) {
    final cells = <String, List<Alerta>>{};
    for (final alerta in alertas) {
      final cell = GeoUtils.clusterCell(alerta.latitude, alerta.longitude, zoom);
      cells.putIfAbsent(cell, () => []).add(alerta);
    }
    return cells;
  }

  static List<AlertaCluster> _buildClusters(
    Map<String, List<Alerta>> cells,
    int minClusterSize,
  ) {
    final clusters = <AlertaCluster>[];
    for (final entry in cells.entries) {
      final group = entry.value;

      if (group.length < minClusterSize) {
        clusters.addAll(group.map((alerta) => _pin(alerta, entry.key)));
        continue;
      }

      final avgLat =
          group.map((a) => a.latitude).reduce((a, b) => a + b) / group.length;
      final avgLon =
          group.map((a) => a.longitude).reduce((a, b) => a + b) / group.length;

      clusters.add(
        AlertaCluster(
          id: 'cluster_${entry.key}',
          centerLatitude: avgLat,
          centerLongitude: avgLon,
          alertas: group,
          cellKey: entry.key,
        ),
      );
    }
    return clusters;
  }

  static List<AlertaCluster> _buildIndividualPins(
    List<Alerta> alertas,
    double zoom,
  ) {
    return alertas
        .map((alerta) => _pin(alerta, GeoUtils.clusterCell(alerta.latitude, alerta.longitude, zoom)))
        .toList(growable: false);
  }

  static AlertaCluster _pin(Alerta alerta, String cell) {
    return AlertaCluster(
      id: 'pin_${alerta.mergeKey}',
      centerLatitude: alerta.latitude,
      centerLongitude: alerta.longitude,
      alertas: [alerta],
      cellKey: cell,
    );
  }
}
