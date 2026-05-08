import 'dart:async';

import '../network/network_connection_monitor.dart';
import '../observability/telemetry.dart';
import 'ocorrencia_sync_worker.dart';

typedef SyncPendingOcorrencias = Future<SyncResult> Function();

class OcorrenciaSyncOrchestrator {
  OcorrenciaSyncOrchestrator({
    required NetworkStatusListenable network,
    required SyncPendingOcorrencias syncPendingOcorrencias,
    required Telemetry telemetry,
    Duration debounce = const Duration(seconds: 2),
  }) : _network = network,
       _syncPendingOcorrencias = syncPendingOcorrencias,
       _telemetry = telemetry,
       _debounce = debounce,
       _lastStatus = network.status;

  final NetworkStatusListenable _network;
  final SyncPendingOcorrencias _syncPendingOcorrencias;
  final Telemetry _telemetry;
  final Duration _debounce;

  NetworkConnectionStatus _lastStatus;
  Timer? _recoveryDebounce;
  bool _isStarted = false;
  bool _isSyncing = false;

  void start() {
    if (_isStarted) return;
    _isStarted = true;
    _network.addListener(_onNetworkChanged);
  }

  void _onNetworkChanged() {
    final previous = _lastStatus;
    final current = _network.status;
    _lastStatus = current;

    final recovered =
        previous != NetworkConnectionStatus.online &&
        current == NetworkConnectionStatus.online;
    if (!recovered) return;

    _recoveryDebounce?.cancel();
    _recoveryDebounce = Timer(_debounce, () {
      unawaited(_runRecoveredSync());
    });
  }

  Future<void> _runRecoveredSync() async {
    if (_isSyncing) return;
    _isSyncing = true;
    _telemetry.log(TelemetryEvents.syncNetworkRecoveredTrigger);
    try {
      await _syncPendingOcorrencias();
    } finally {
      _isSyncing = false;
    }
  }

  void dispose() {
    _recoveryDebounce?.cancel();
    if (_isStarted) {
      _network.removeListener(_onNetworkChanged);
      _isStarted = false;
    }
  }
}
