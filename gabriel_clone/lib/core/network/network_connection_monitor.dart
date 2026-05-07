import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

enum NetworkConnectionStatus { unknown, online, offline, poor }

class NetworkConnectionMonitor extends ChangeNotifier {
  NetworkConnectionMonitor({
    Duration checkInterval = const Duration(seconds: 20),
    Duration timeout = const Duration(seconds: 3),
    Duration poorConnectionThreshold = const Duration(milliseconds: 1500),
  }) : _checkInterval = checkInterval,
       _timeout = timeout,
       _poorConnectionThreshold = poorConnectionThreshold {
    unawaited(checkNow());
    _timer = Timer.periodic(_checkInterval, (_) => unawaited(checkNow()));
  }

  final Duration _checkInterval;
  final Duration _timeout;
  final Duration _poorConnectionThreshold;
  Timer? _timer;
  NetworkConnectionStatus _status = NetworkConnectionStatus.unknown;

  NetworkConnectionStatus get status => _status;

  /// Callback acionado na transição de offline/poor/unknown → online.
  /// Usado pelo WorkManager para disparar sync imediato ao recuperar conexão.
  VoidCallback? onBackOnline;

  Future<void> checkNow() async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(_timeout);
      stopwatch.stop();
      if (result.isEmpty || result.first.rawAddress.isEmpty) {
        _setStatus(NetworkConnectionStatus.offline);
        return;
      }

      _setStatus(
        stopwatch.elapsed > _poorConnectionThreshold
            ? NetworkConnectionStatus.poor
            : NetworkConnectionStatus.online,
      );
    } on TimeoutException {
      _setStatus(NetworkConnectionStatus.poor);
    } on SocketException {
      _setStatus(NetworkConnectionStatus.offline);
    } catch (_) {
      _setStatus(NetworkConnectionStatus.unknown);
    }
  }

  void _setStatus(NetworkConnectionStatus newStatus) {
    if (_status == newStatus) {
      return;
    }

    final wasOffline = _status != NetworkConnectionStatus.online;
    final isNowOnline = newStatus == NetworkConnectionStatus.online;

    _status = newStatus;
    notifyListeners();

    // Dispara callback de "voltou online" para acionar sync imediato
    if (wasOffline && isNowOnline) {
      onBackOnline?.call();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
