import 'dart:async';
import 'package:battery_plus/battery_plus.dart';

typedef BatteryBelowThreshold = void Function(int level);

class BatteryLevelWatcher {
  BatteryLevelWatcher({
    Battery? battery,
    this.threshold = 20,
    this.pollInterval = const Duration(seconds: 10),
    required this.onBelowThreshold,
  }) : _battery = battery ?? Battery();

  final Battery _battery;
  final int threshold;
  final Duration pollInterval;
  final BatteryBelowThreshold onBelowThreshold;

  StreamSubscription<BatteryState>? _sub;
  Timer? _poll;
  bool _askedThisSession = false;

  void start() {
    _poll = Timer.periodic(pollInterval, (_) => _checkLevel());
    _sub = _battery.onBatteryStateChanged.listen((_) => _checkLevel());
    // checa imediatamente também
    _checkLevel();
  }

  Future<void> _checkLevel() async {
    try {
      final level = await _battery.batteryLevel;
      if (level <= threshold && !_askedThisSession) {
        _askedThisSession = true;
        onBelowThreshold(level);
      }
    } catch (_) {
      // ignore erros de leitura
    }
  }

  Future<int?> readOnce() async {
    try {
      return await _battery.batteryLevel;
    } catch (_) {
      return null;
    }
  }

  void resetSessionFlag() => _askedThisSession = false;

  void dispose() {
    _sub?.cancel();
    _poll?.cancel();
  }
}
