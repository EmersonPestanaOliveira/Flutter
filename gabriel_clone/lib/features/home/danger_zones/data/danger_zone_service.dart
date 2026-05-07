import 'package:flutter/foundation.dart';

import '../../domain/entities/alerta.dart';
import '../../domain/enums/alerta_tipo.dart';
import '../domain/danger_zone.dart';
import '../domain/danger_zone_calculator.dart';
import '../domain/danger_zone_config.dart';
import 'danger_zone_remote_config_service.dart';

class DangerZoneService {
  DangerZoneService({
    DangerZoneRemoteConfigService? remoteConfigService,
    DangerZoneCalculator? calculator,
  }) : _remoteConfigService =
           remoteConfigService ?? DangerZoneRemoteConfigService(),
       _calculator = calculator ?? const DangerZoneCalculator();

  final DangerZoneRemoteConfigService _remoteConfigService;
  final DangerZoneCalculator _calculator;

  Future<DangerZoneServiceResult> loadZones(List<Alerta> events) async {
    final config = await _remoteConfigService.loadConfig();
    if (kDebugMode) {
      final now = DateTime.now();
      final cutoff = now.subtract(config.timeWindow);
      final countsByType = <String, int>{};
      var validLocationCount = 0;
      var recentCount = 0;
      for (final event in events) {
        countsByType.update(
          event.tipo.label,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
        if (event.latitude != 0 && event.longitude != 0) {
          validLocationCount++;
        }
        if (!event.data.isBefore(cutoff)) {
          recentCount++;
        }
      }
      debugPrint(
        '[DangerZones] config enabled=${config.enabled} '
        'minEvents=${config.minEvents} radius=${config.radiusMeters}m '
        'window=${config.timeWindowHours}h events=${events.length}',
      );
      debugPrint(
        '[DangerZones] validLocation=$validLocationCount '
        'recent=$recentCount cutoff=$cutoff',
      );
      debugPrint('[DangerZones] eventCountsByType=$countsByType');
    }

    if (!config.enabled) {
      return DangerZoneServiceResult(config: config, zones: const []);
    }

    final zones = _calculator.calculate(events: events, config: config);
    if (kDebugMode) {
      debugPrint('[DangerZones] zones=${zones.length}');
      for (final zone in zones) {
        debugPrint(
          '[DangerZones] ${zone.eventType} count=${zone.eventCount} '
          'center=${zone.center.latitude},${zone.center.longitude}',
        );
      }
    }
    return DangerZoneServiceResult(config: config, zones: zones);
  }
}

class DangerZoneServiceResult {
  const DangerZoneServiceResult({required this.config, required this.zones});

  final DangerZoneConfig config;
  final List<DangerZone> zones;
}
