import 'dart:async';
import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/danger_zone.dart';
import '../domain/danger_zone_config.dart';
import 'danger_zone_notification_service.dart';

class DangerZoneLocationMonitor {
  DangerZoneLocationMonitor({
    required SharedPreferences preferences,
    DangerZoneNotificationService? notificationService,
  }) : _preferences = preferences,
       _notificationService =
           notificationService ?? DangerZoneNotificationService();

  static const _lastNotificationPrefix = 'danger_zone_last_notification_';

  final SharedPreferences _preferences;
  final DangerZoneNotificationService _notificationService;
  StreamSubscription<Position>? _subscription;
  List<DangerZone> _zones = const [];
  DangerZoneConfig _config = DangerZoneConfig.disabled;

  Future<void> start({
    required List<DangerZone> zones,
    required DangerZoneConfig config,
  }) async {
    await stop();

    if (!config.enabled || zones.isEmpty) {
      return;
    }

    _zones = zones;
    _config = config;

    final hasPermission = await _ensureLocationPermission();
    if (!hasPermission) {
      return;
    }

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      final currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      await _handlePosition(currentPosition);

      _subscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 50,
        ),
      ).listen(_handlePosition, onError: (_) {});
    } catch (_) {
      await stop();
    }
  }

  Future<void> updateZones({
    required List<DangerZone> zones,
    required DangerZoneConfig config,
  }) async {
    if (!config.enabled || zones.isEmpty) {
      await stop();
      return;
    }

    _zones = zones;
    _config = config;
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    _zones = const [];
    _config = DangerZoneConfig.disabled;
  }

  Future<bool> _ensureLocationPermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<void> _handlePosition(Position position) async {
    if (!_config.enabled || _zones.isEmpty) {
      return;
    }

    final userLocation = LatLng(position.latitude, position.longitude);
    for (final zone in _zones) {
      final distance = _distanceMeters(userLocation, zone.center);
      if (distance > zone.radiusMeters) {
        continue;
      }

      if (!_canNotify(zone)) {
        continue;
      }

      await _notificationService.showDangerZoneAlert(zone);
      await _saveNotificationTime(zone);
    }
  }

  bool _canNotify(DangerZone zone) {
    final lastTimestamp = _preferences.getInt(_notificationKey(zone));
    if (lastTimestamp == null) {
      return true;
    }

    final lastNotification = DateTime.fromMillisecondsSinceEpoch(lastTimestamp);
    return DateTime.now().difference(lastNotification) >=
        _config.notificationCooldown;
  }

  Future<void> _saveNotificationTime(DangerZone zone) async {
    await _preferences.setInt(
      _notificationKey(zone),
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  String _notificationKey(DangerZone zone) {
    return '$_lastNotificationPrefix${zone.id}';
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
