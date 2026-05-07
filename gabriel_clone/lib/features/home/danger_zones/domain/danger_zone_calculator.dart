import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/alerta.dart';
import '../../domain/enums/alerta_tipo.dart';
import '../../presentation/widgets/alert_pin_factory.dart';
import 'danger_zone.dart';
import 'danger_zone_config.dart';

class DangerZoneCalculator {
  const DangerZoneCalculator();

  List<DangerZone> calculate({
    required List<Alerta> events,
    required DangerZoneConfig config,
    DateTime? now,
  }) {
    if (!config.enabled) {
      return const [];
    }

    final referenceTime = now ?? DateTime.now();
    final cutoff = referenceTime.subtract(config.timeWindow);
    final recentEvents = events
        .where(
          (event) =>
              event.latitude != 0 &&
              event.longitude != 0 &&
              !event.data.isBefore(cutoff),
        )
        .toList(growable: false);

    final eventsByType = <String, List<Alerta>>{};
    for (final event in recentEvents) {
      eventsByType.putIfAbsent(event.tipo.label, () => []).add(event);
    }

    final zones = <DangerZone>[];
    for (final entry in eventsByType.entries) {
      zones.addAll(
        _calculateTypeZones(
          eventType: entry.key,
          events: entry.value,
          config: config,
          now: referenceTime,
        ),
      );
    }

    return zones;
  }

  List<DangerZone> _calculateTypeZones({
    required String eventType,
    required List<Alerta> events,
    required DangerZoneConfig config,
    required DateTime now,
  }) {
    final candidates = <_DangerZoneCandidate>[];
    for (final event in events) {
      final nearby = events.where((other) {
        return _distanceMeters(
              LatLng(event.latitude, event.longitude),
              LatLng(other.latitude, other.longitude),
            ) <=
            config.radiusMeters;
      }).toList(growable: false);

      if (nearby.length < config.minEvents) {
        continue;
      }

      final center = _averageCenter(nearby);
      candidates.add(
        _DangerZoneCandidate(
          eventType: eventType,
          color: AlertPinFactory.color(event.tipo),
          center: center,
          radiusMeters: config.radiusMeters,
          eventCount: nearby.length,
          updatedAt: now,
        ),
      );
    }

    candidates.sort((a, b) => b.eventCount.compareTo(a.eventCount));

    final zones = <DangerZone>[];
    for (final candidate in candidates) {
      final isDuplicate = zones.any((zone) {
        return _distanceMeters(zone.center, candidate.center) <
            config.radiusMeters;
      });
      if (isDuplicate) {
        continue;
      }

      zones.add(candidate.toZone(index: zones.length));
    }

    return zones;
  }

  LatLng _averageCenter(List<Alerta> events) {
    final latitude =
        events.map((event) => event.latitude).reduce((a, b) => a + b) /
        events.length;
    final longitude =
        events.map((event) => event.longitude).reduce((a, b) => a + b) /
        events.length;
    return LatLng(latitude, longitude);
  }

  double _distanceMeters(LatLng a, LatLng b) {
    const earthRadiusMeters = 6371000.0;
    final dLat = _toRadians(b.latitude - a.latitude);
    final dLng = _toRadians(b.longitude - a.longitude);
    final lat1 = _toRadians(a.latitude);
    final lat2 = _toRadians(b.latitude);

    final haversine =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);

    return earthRadiusMeters *
        2 *
        math.atan2(math.sqrt(haversine), math.sqrt(1 - haversine));
  }

  double _toRadians(double degrees) => degrees * math.pi / 180;
}

class _DangerZoneCandidate {
  const _DangerZoneCandidate({
    required this.eventType,
    required this.color,
    required this.center,
    required this.radiusMeters,
    required this.eventCount,
    required this.updatedAt,
  });

  final String eventType;
  final Color color;
  final LatLng center;
  final double radiusMeters;
  final int eventCount;
  final DateTime updatedAt;

  DangerZone toZone({required int index}) {
    final typeSlug = eventType
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    final lat = (center.latitude * 10000).round();
    final lng = (center.longitude * 10000).round();

    return DangerZone(
      id: 'danger_zone_${typeSlug}_${lat}_${lng}_$index',
      eventType: eventType,
      color: color,
      center: center,
      radiusMeters: radiusMeters,
      eventCount: eventCount,
      updatedAt: updatedAt,
    );
  }
}
