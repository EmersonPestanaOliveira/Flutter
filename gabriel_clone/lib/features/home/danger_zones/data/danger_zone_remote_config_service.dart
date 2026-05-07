import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import '../domain/danger_zone_config.dart';

class DangerZoneRemoteConfigService {
  DangerZoneRemoteConfigService({FirebaseRemoteConfig? remoteConfig})
    : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

  static const enabledKey = 'danger_zones_enabled';
  static const minEventsKey = 'danger_zones_min_events';
  static const radiusMetersKey = 'danger_zones_radius_meters';
  static const timeWindowHoursKey = 'danger_zones_time_window_hours';
  static const cooldownMinutesKey =
      'danger_zones_notification_cooldown_minutes';

  final FirebaseRemoteConfig _remoteConfig;
  bool _configured = false;

  Future<DangerZoneConfig> loadConfig() async {
    try {
      if (!_configured) {
        await _remoteConfig.setDefaults(const {
          enabledKey: false,
          minEventsKey: 5,
          radiusMetersKey: 300,
          timeWindowHoursKey: 72,
          cooldownMinutesKey: 60,
        });
        await _remoteConfig.setConfigSettings(
          RemoteConfigSettings(
            fetchTimeout: const Duration(seconds: 5),
            minimumFetchInterval: kDebugMode
                ? Duration.zero
                : const Duration(minutes: 15),
          ),
        );
        _configured = true;
      }

      await _remoteConfig.fetchAndActivate();

      return DangerZoneConfig(
        enabled: _remoteConfig.getBool(enabledKey),
        minEvents: _safeInt(_remoteConfig.getInt(minEventsKey), fallback: 5),
        radiusMeters: _safeDouble(
          _remoteConfig.getDouble(radiusMetersKey),
          fallback: 300,
        ),
        timeWindowHours: _safeInt(
          _remoteConfig.getInt(timeWindowHoursKey),
          fallback: 72,
        ),
        notificationCooldownMinutes: _safeInt(
          _remoteConfig.getInt(cooldownMinutesKey),
          fallback: 60,
        ),
      );
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[DangerZones] Remote Config failed: $error');
      }
      return DangerZoneConfig.disabled;
    }
  }

  int _safeInt(int value, {required int fallback}) {
    return value > 0 ? value : fallback;
  }

  double _safeDouble(double value, {required double fallback}) {
    return value > 0 ? value : fallback;
  }
}
