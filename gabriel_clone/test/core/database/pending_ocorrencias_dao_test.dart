import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/core/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  late Database sqlite;
  late PendingOcorrenciasDao dao;

  setUp(() {
    sqlite = sqlite3.openInMemory();
    final db = AppDatabase.forTesting(sqlite);
    dao = db.pendingOcorrenciasDao;
  });

  tearDown(() => sqlite.dispose());

  group('enqueue / persistência', () {
    test('persiste um item com status queued', () async {
      await dao.enqueue(_companion('c1'));
      final rows = sqlite.select('SELECT * FROM pending_ocorrencias');
      expect(rows.length, 1);
      expect(rows.first['status'], 'queued');
      expect(rows.first['attempt_count'], 0);
    });

    test('enqueue idempotente: segundo enqueue faz upsert', () async {
      await dao.enqueue(_companion('c1'));
      await dao.enqueue(_companion('c1', payload: '{"updated":true}'));
      final rows = sqlite.select('SELECT * FROM pending_ocorrencias');
      expect(rows.length, 1);
      expect(rows.first['payload_json'], '{"updated":true}');
    });

    test('serialização round-trip do payload JSON', () async {
      const payload = '{"informacoes":"teste","quando":"2026-05-06T10:00:00.000"'
          ',"horario":"10:00","latitude":-23.5,"longitude":-46.6'
          ',"enderecoBusca":"R","cienteBoletim":true,"aceitePrivacidade":true}';
      await dao.enqueue(_companion('c1', payload: payload));
      final pending = await dao.getPendingForSync();
      expect(pending.single.payloadJson, payload);
    });
  });

  group('transições de status', () {
    test('markSyncing -> syncing', () async {
      await dao.enqueue(_companion('c1'));
      await dao.markSyncing('c1');
      final row = sqlite.select('SELECT status FROM pending_ocorrencias').first;
      expect(row['status'], 'syncing');
    });

    test('markSynced -> synced', () async {
      await dao.enqueue(_companion('c1'));
      await dao.markSynced('c1');
      final row = sqlite.select('SELECT status FROM pending_ocorrencias').first;
      expect(row['status'], 'synced');
    });

    test('markFailed incrementa attempt_count e agenda retry', () async {
      await dao.enqueue(_companion('c1'));
      await dao.markFailed('c1', 'timeout');
      final row = sqlite.select('SELECT * FROM pending_ocorrencias').first;
      expect(row['attempt_count'], 1);
      expect(row['status'], PendingStatus.failed.name);
      expect(row['next_attempt_at'] as int, greaterThan(0));
    });

    test('5 falhas -> deadLetter', () async {
      await dao.enqueue(_companion('c1', attemptCount: 4));
      await dao.markFailed('c1', 'timeout');
      final row = sqlite.select('SELECT * FROM pending_ocorrencias').first;
      expect(row['status'], PendingStatus.deadLetter.name);
      expect(row['attempt_count'], 5);
    });
  });

  group('resetToQueued', () {
    test('recoloca deadLetter em queued com attempt=0', () async {
      await dao.enqueue(_companion('c1', attemptCount: 4));
      await dao.markFailed('c1', 'err');
      await dao.resetToQueued('c1');
      final row = sqlite.select('SELECT * FROM pending_ocorrencias').first;
      expect(row['status'], PendingStatus.queued.name);
      expect(row['attempt_count'], 0);
      expect(row['last_error'], isNull);
    });
  });

  group('recuperação de syncing antigo', () {
    test('syncing com updatedAt >10min volta para failed', () async {
      final staleMs = DateTime.now()
          .subtract(const Duration(minutes: 15))
          .millisecondsSinceEpoch;
      await dao.enqueue(_companion('c1', status: 'syncing', updatedAt: staleMs));
      final pending = await dao.getPendingForSync();
      expect(pending.single.status, PendingStatus.failed.name);
    });

    test('syncing recente não é resetado', () async {
      await dao.enqueue(_companion('c1'));
      await dao.markSyncing('c1');
      // syncing recente: getPendingForSync não retorna (não elegível)
      final pending = await dao.getPendingForSync();
      expect(pending, isEmpty);
    });
  });

  group('purgeSynced', () {
    test('remove apenas synced', () async {
      await dao.enqueue(_companion('c1'));
      await dao.enqueue(_companion('c2'));
      await dao.markSynced('c1');
      await dao.purgeSynced();
      final rows = sqlite.select('SELECT client_id FROM pending_ocorrencias');
      expect(rows.length, 1);
      expect(rows.first['client_id'], 'c2');
    });
  });

  group('watchPending inclui deadLetter', () {
    test('deadLetter aparece no stream; synced não aparece', () async {
      await dao.enqueue(_companion('c1'));
      await dao.enqueue(_companion('c2', attemptCount: 4));
      await dao.markFailed('c2', 'err'); // -> deadLetter
      await dao.enqueue(_companion('c3'));
      await dao.markSynced('c3');
      final list = await dao.watchPending().first;
      final ids = list.map((e) => e.clientId).toSet();
      expect(ids, contains('c1'));
      expect(ids, contains('c2'));
      expect(ids, isNot(contains('c3')));
    });
  });
}

PendingOcorrenciasCompanion _companion(
  String clientId, {
  String? payload,
  String status = 'queued',
  int attemptCount = 0,
  int? updatedAt,
}) {
  final now = DateTime.now().millisecondsSinceEpoch;
  return PendingOcorrenciasCompanion(
    clientId: clientId,
    payloadJson: payload ??
        '{"informacoes":"t","quando":"2026-05-06T10:00:00.000",'
            '"horario":"10:00","latitude":-23.5,"longitude":-46.6,'
            '"enderecoBusca":"R","cienteBoletim":true,"aceitePrivacidade":true}',
    attachmentsJson: '[]',
    status: status,
    attemptCount: attemptCount,
    createdAt: now,
    updatedAt: updatedAt ?? now,
  );
}
