import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class StressPinsConfig {
  const StressPinsConfig({
    required this.enabled,
    required this.count,
  });

  static const disabled = StressPinsConfig(enabled: false, count: 0);

  final bool enabled;
  final int count;
}

abstract interface class StressPinsConfigService {
  Future<StressPinsConfig> loadConfig();
}

class FirebaseStressPinsConfigService implements StressPinsConfigService {
  FirebaseStressPinsConfigService({FirebaseRemoteConfig? remoteConfig})
    : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

  static const enabledKey = 'map_stress_pins_enabled';
  static const countKey = 'map_stress_pins_count';
  static const maxPins = 100000;

  final FirebaseRemoteConfig _remoteConfig;
  bool _configured = false;

  @override
  Future<StressPinsConfig> loadConfig() async {
    try {
      if (!_configured) {
        await _remoteConfig.setDefaults(const {
          enabledKey: false,
          countKey: 0,
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

      final enabled = _remoteConfig.getBool(enabledKey);
      final count = _safeCount(_remoteConfig.getInt(countKey));
      return StressPinsConfig(enabled: enabled, count: count);
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[StressPins] Remote Config failed: $error');
      }
      return StressPinsConfig.disabled;
    }
  }

  int _safeCount(int value) {
    if (value <= 0) return 0;
    if (value > maxPins) return maxPins;
    return value;
  }
}
