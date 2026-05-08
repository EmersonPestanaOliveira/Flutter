import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/core/network/network_connection_monitor.dart';
import 'package:gabriel_clone/core/observability/telemetry.dart';
import 'package:gabriel_clone/core/sync/ocorrencia_sync_orchestrator.dart';
import 'package:gabriel_clone/core/sync/ocorrencia_sync_worker.dart';

void main() {
  late FakeNetworkMonitor network;
  late FakeTelemetry telemetry;

  setUp(() {
    network = FakeNetworkMonitor(NetworkConnectionStatus.offline);
    telemetry = FakeTelemetry();
  });

  test('dispara sync ao recuperar rede', () async {
    var syncCount = 0;
    final orchestrator = OcorrenciaSyncOrchestrator(
      network: network,
      syncPendingOcorrencias: () async {
        syncCount++;
        return const SyncResult(total: 1, success: 1, failed: 0);
      },
      telemetry: telemetry,
      debounce: const Duration(milliseconds: 20),
    )..start();

    network.status = NetworkConnectionStatus.online;
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(syncCount, 1);
    expect(
      telemetry.events,
      contains(TelemetryEvents.syncNetworkRecoveredTrigger),
    );
    orchestrator.dispose();
  });

  test('debounce evita disparos extras em flapping rapido', () async {
    var syncCount = 0;
    final orchestrator = OcorrenciaSyncOrchestrator(
      network: network,
      syncPendingOcorrencias: () async {
        syncCount++;
        return const SyncResult(total: 1, success: 1, failed: 0);
      },
      telemetry: telemetry,
      debounce: const Duration(milliseconds: 40),
    )..start();

    network.status = NetworkConnectionStatus.online;
    await Future<void>.delayed(const Duration(milliseconds: 10));
    network.status = NetworkConnectionStatus.offline;
    await Future<void>.delayed(const Duration(milliseconds: 10));
    network.status = NetworkConnectionStatus.online;
    await Future<void>.delayed(const Duration(milliseconds: 70));

    expect(syncCount, 1);
    orchestrator.dispose();
  });

  test('nao dispara se ja esta sincronizando', () async {
    var syncCount = 0;
    final completer = Completer<void>();
    final orchestrator = OcorrenciaSyncOrchestrator(
      network: network,
      syncPendingOcorrencias: () async {
        syncCount++;
        await completer.future;
        return const SyncResult(total: 1, success: 1, failed: 0);
      },
      telemetry: telemetry,
      debounce: const Duration(milliseconds: 10),
    )..start();

    network.status = NetworkConnectionStatus.online;
    await Future<void>.delayed(const Duration(milliseconds: 30));
    network.status = NetworkConnectionStatus.offline;
    network.status = NetworkConnectionStatus.online;
    await Future<void>.delayed(const Duration(milliseconds: 30));

    expect(syncCount, 1);
    completer.complete();
    await Future<void>.delayed(Duration.zero);
    orchestrator.dispose();
  });
}

class FakeNetworkMonitor extends ChangeNotifier
    implements NetworkStatusListenable {
  FakeNetworkMonitor(this._status);

  NetworkConnectionStatus _status;

  @override
  NetworkConnectionStatus get status => _status;

  set status(NetworkConnectionStatus next) {
    if (_status == next) return;
    _status = next;
    notifyListeners();
  }
}

class FakeTelemetry extends Telemetry {
  FakeTelemetry();

  final events = <String>[];

  @override
  void log(String event, {Map<String, Object?> params = const {}}) {
    events.add(event);
  }
}
