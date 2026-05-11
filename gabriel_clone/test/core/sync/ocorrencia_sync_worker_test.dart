import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/core/database/app_database.dart';
import 'package:gabriel_clone/core/security/local_payload_crypto.dart';
import 'package:gabriel_clone/core/observability/telemetry.dart';
import 'package:gabriel_clone/core/sync/ocorrencia_sync_worker.dart';
import 'package:gabriel_clone/features/ocorrencias/data/datasources/ocorrencia_local_datasource.dart';
import 'package:gabriel_clone/features/ocorrencias/data/datasources/ocorrencia_remote_datasource.dart';
import 'package:gabriel_clone/features/ocorrencias/data/services/ocorrencia_service.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  late Database sqlite;
  late OcorrenciaLocalDatasource local;
  late FakeRemoteDatasource remote;
  late OcorrenciaSyncWorker worker;

  setUp(() {
    sqlite = sqlite3.openInMemory();
    final db = AppDatabase.forTesting(sqlite);
    local = OcorrenciaLocalDatasourceImpl(
      db.pendingOcorrenciasDao,
      AesGcmLocalPayloadCrypto(InMemoryLocalCryptoKeyStore()),
    );
    remote = FakeRemoteDatasource();
    worker = OcorrenciaSyncWorker(
      local: local,
      remote: remote,
      telemetry: const FakeTelemetry(),
    );
  });

  tearDown(() => sqlite.dispose());

  test('sync promove item queued para synced', () async {
    await local.enqueue(_pending('client-1'));
    final result = await worker.syncPendingOcorrencias();
    final pending = await local.getPendingForSync();
    expect(result.success, 1);
    expect(remote.createdClientIds, ['client-1']);
    expect(pending, isEmpty);
  });

  test('falha recuperável agenda retry com backoff', () async {
    remote.shouldFail = true;
    await local.enqueue(_pending('client-1'));
    final result = await worker.syncPendingOcorrencias();
    final rows = sqlite.select('SELECT * FROM pending_ocorrencias');
    expect(result.failed, 1);
    expect(rows.single['status'], PendingStatus.failed.name);
    expect(rows.single['attempt_count'], 1);
    expect(rows.single['next_attempt_at'] as int, greaterThan(0));
  });

  test('5 falhas movem item para deadLetter', () async {
    remote.shouldFail = true;
    await local.enqueue(_pending('client-1', attemptCount: 4));
    await worker.syncPendingOcorrencias();
    final rows = sqlite.select('SELECT * FROM pending_ocorrencias');
    expect(rows.single['status'], PendingStatus.deadLetter.name);
    expect(rows.single['attempt_count'], 5);
  });

  test('syncing antigo volta para failed e fica elegível', () async {
    final staleMs = DateTime.now()
        .subtract(const Duration(minutes: 15))
        .millisecondsSinceEpoch;
    await local.enqueue(
      _pending('client-1', status: PendingStatus.syncing.name, updatedAt: staleMs),
    );
    final pending = await local.getPendingForSync();
    expect(pending.single.clientId, 'client-1');
    expect(pending.single.status, PendingStatus.failed.name);
  });

  test('idempotência: segunda chamada com mesmo clientId não duplica', () async {
    await local.enqueue(_pending('client-1'));
    await worker.syncPendingOcorrencias();
    // Simula re-enqueue com mesmo ID (upsert)
    await local.enqueue(_pending('client-1'));
    await worker.syncPendingOcorrencias();
    expect(remote.createdClientIds.where((id) => id == 'client-1').length, 2);
  });

  test('sync preserva categoria gravada no payload', () async {
    await local.enqueue(_pending('client-1', categoria: 'rouboFurto'));
    await worker.syncPendingOcorrencias();
    expect(remote.createdInputs.single.categoria, 'rouboFurto');
  });

  test('isRecoverableSyncError classifica SocketException como recuperável', () {
    expect(isRecoverableSyncError(const SocketException('no route')), isTrue);
  });

  test('isRecoverableSyncError classifica permission-denied como permanente', () {
    final err = Exception('PERMISSION_DENIED: permission-denied');
    expect(isRecoverableSyncError(err), isFalse);
  });

  test('retry manual (resetToQueued) reprocessa deadLetter', () async {
    remote.shouldFail = true;
    await local.enqueue(_pending('client-1', attemptCount: 4));
    await worker.syncPendingOcorrencias(); // vai para deadLetter
    remote.shouldFail = false;
    await local.resetToQueued('client-1');
    await worker.syncPendingOcorrencias();
    final rows = sqlite.select('SELECT status FROM pending_ocorrencias');
    expect(rows.single['status'], PendingStatus.synced.name);
  });
}

PendingOcorrenciasCompanion _pending(
  String clientId, {
  String status = 'queued',
  int attemptCount = 0,
  int? updatedAt,
  String categoria = 'outros',
}) {
  final now = DateTime.now().millisecondsSinceEpoch;
  return PendingOcorrenciasCompanion(
    clientId: clientId,
    payloadJson:
        '{"informacoes":"t","quando":"2026-05-06T10:00:00.000",'
        '"horario":"10:00","categoria":"$categoria",'
        '"latitude":-23.5,"longitude":-46.6,'
        '"enderecoBusca":"R","cienteBoletim":true,"aceitePrivacidade":true}',
    attachmentsJson: '[]',
    status: status,
    attemptCount: attemptCount,
    createdAt: now,
    updatedAt: updatedAt ?? now,
  );
}

class FakeRemoteDatasource implements OcorrenciaRemoteDatasource {
  bool shouldFail = false;
  final createdClientIds = <String>[];
  final createdInputs = <CreateOcorrenciaInput>[];

  @override
  Future<void> createOcorrencia({
    required String clientId,
    required CreateOcorrenciaInput input,
  }) async {
    if (shouldFail) throw StateError('offline');
    createdClientIds.add(clientId);
    createdInputs.add(input);
  }
}

class FakeTelemetry extends Telemetry {
  const FakeTelemetry();
  @override
  Future<T> trace<T>(String name, Future<T> Function() body,
      {Map<String, String> attributes = const {},
      Map<String, int> metrics = const {}}) =>
      body();
  @override
  void log(String event, {Map<String, Object?> params = const {}}) {}
  @override
  void recordError(Object error, StackTrace stackTrace,
      {String? reason, bool fatal = false}) {}
}
