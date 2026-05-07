import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

enum PendingStatus { queued, syncing, failed, synced, deadLetter }

class PendingOcorrencia {
  const PendingOcorrencia({
    required this.clientId,
    required this.payloadJson,
    required this.attachmentsJson,
    required this.status,
    required this.attemptCount,
    required this.nextAttemptAt,
    required this.createdAt,
    required this.updatedAt,
    this.lastError,
  });

  final String clientId;
  final String payloadJson;
  final String attachmentsJson;
  final String status;
  final int attemptCount;
  final int nextAttemptAt;
  final String? lastError;
  final int createdAt;
  final int updatedAt;

  bool get isTerminal =>
      status == PendingStatus.synced.name ||
      status == PendingStatus.deadLetter.name;
}

class PendingOcorrenciasCompanion {
  const PendingOcorrenciasCompanion({
    required this.clientId,
    required this.payloadJson,
    this.attachmentsJson = '[]',
    this.status = 'queued',
    this.attemptCount = 0,
    this.nextAttemptAt = 0,
    this.lastError,
    required this.createdAt,
    required this.updatedAt,
  });

  final String clientId;
  final String payloadJson;
  final String attachmentsJson;
  final String status;
  final int attemptCount;
  final int nextAttemptAt;
  final String? lastError;
  final int createdAt;
  final int updatedAt;
}

class AppDatabase {
  AppDatabase() : pendingOcorrenciasDao = PendingOcorrenciasDao();

  @visibleForTesting
  AppDatabase.forTesting(Database database)
      : pendingOcorrenciasDao = PendingOcorrenciasDao.forTesting(database);

  final PendingOcorrenciasDao pendingOcorrenciasDao;
}

class PendingOcorrenciasDao {
  PendingOcorrenciasDao();

  @visibleForTesting
  PendingOcorrenciasDao.forTesting(Database database) : _db = database {
    _ensureSchema(database);
  }

  static const int maxAttempts = 5;
  static const Duration staleSyncingAfter = Duration(minutes: 10);

  Database? _db;
  final _changes = StreamController<void>.broadcast();

  Future<Database> get _database async {
    final existing = _db;
    if (existing != null) return existing;

    final directory = await getApplicationDocumentsDirectory();
    final dbDir = Directory(p.join(directory.path, 'database'));
    await dbDir.create(recursive: true);
    final db = sqlite3.open(p.join(dbDir.path, 'gabriel_clone.sqlite'));
    _ensureSchema(db);
    _db = db;
    return db;
  }

  static void _ensureSchema(Database db) {
    db.execute('''
      CREATE TABLE IF NOT EXISTS pending_ocorrencias (
        client_id TEXT PRIMARY KEY,
        payload_json TEXT NOT NULL,
        attachments_json TEXT NOT NULL,
        status TEXT NOT NULL,
        attempt_count INTEGER NOT NULL DEFAULT 0,
        next_attempt_at INTEGER NOT NULL DEFAULT 0,
        last_error TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      );
    ''');
    _addColumnIfMissing(
      db,
      'pending_ocorrencias',
      'next_attempt_at',
      'INTEGER NOT NULL DEFAULT 0',
    );
    db.execute(
      'CREATE INDEX IF NOT EXISTS idx_pending_status '
      'ON pending_ocorrencias(status);',
    );
    db.execute(
      'CREATE INDEX IF NOT EXISTS idx_pending_next_attempt '
      'ON pending_ocorrencias(status, next_attempt_at);',
    );
    db.execute(
      'CREATE INDEX IF NOT EXISTS idx_pending_created '
      'ON pending_ocorrencias(created_at);',
    );
  }

  static void _addColumnIfMissing(
    Database db,
    String table,
    String column,
    String definition,
  ) {
    final columns = db.select('PRAGMA table_info($table);');
    final exists = columns.any((row) => row['name'] == column);
    if (!exists) {
      db.execute('ALTER TABLE $table ADD COLUMN $column $definition;');
    }
  }

  Stream<List<PendingOcorrencia>> watchPending() async* {
    yield await _pendingRows();
    await for (final _ in _changes.stream) {
      yield await _pendingRows();
    }
  }

  Future<List<PendingOcorrencia>> getPendingForSync() async {
    final db = await _database;
    final now = DateTime.now().millisecondsSinceEpoch;
    await resetStaleSyncing(nowMs: now);
    final rows = db.select(
      '''
      SELECT * FROM pending_ocorrencias
      WHERE status IN (?, ?)
        AND attempt_count < ?
        AND next_attempt_at <= ?
      ORDER BY created_at ASC
      ''',
      [PendingStatus.queued.name, PendingStatus.failed.name, maxAttempts, now],
    );
    return rows.map(_fromRow).toList(growable: false);
  }

  Future<void> enqueue(PendingOcorrenciasCompanion entry) async {
    final db = await _database;
    db.execute(
      '''
      INSERT INTO pending_ocorrencias (
        client_id,
        payload_json,
        attachments_json,
        status,
        attempt_count,
        next_attempt_at,
        last_error,
        created_at,
        updated_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(client_id) DO UPDATE SET
        payload_json = excluded.payload_json,
        attachments_json = excluded.attachments_json,
        status = excluded.status,
        attempt_count = excluded.attempt_count,
        next_attempt_at = excluded.next_attempt_at,
        last_error = excluded.last_error,
        updated_at = excluded.updated_at
      ''',
      [
        entry.clientId,
        entry.payloadJson,
        entry.attachmentsJson,
        entry.status,
        entry.attemptCount,
        entry.nextAttemptAt,
        entry.lastError,
        entry.createdAt,
        entry.updatedAt,
      ],
    );
    _notifyChanged();
  }

  Future<void> markSyncing(String clientId) async {
    await _updateStatus(clientId, PendingStatus.syncing.name);
  }

  Future<void> markSynced(String clientId) async {
    await _updateStatus(clientId, PendingStatus.synced.name);
  }

  Future<void> markFailed(String clientId, String error) async {
    final db = await _database;
    final row = db.select(
      'SELECT attempt_count FROM pending_ocorrencias WHERE client_id = ?',
      [clientId],
    ).firstOrNull;
    if (row == null) return;

    final nextAttemptCount = (row['attempt_count'] as int) + 1;
    final isDeadLetter = nextAttemptCount >= maxAttempts;
    final nextAttemptAt = isDeadLetter
        ? 0
        : DateTime.now()
            .add(_backoffFor(nextAttemptCount))
            .millisecondsSinceEpoch;

    db.execute(
      '''
      UPDATE pending_ocorrencias
      SET status = ?,
          attempt_count = ?,
          next_attempt_at = ?,
          last_error = ?,
          updated_at = ?
      WHERE client_id = ?
      ''',
      [
        isDeadLetter ? PendingStatus.deadLetter.name : PendingStatus.failed.name,
        nextAttemptCount,
        nextAttemptAt,
        error,
        DateTime.now().millisecondsSinceEpoch,
        clientId,
      ],
    );
    _notifyChanged();
  }

  Future<void> resetStaleSyncing({int? nowMs}) async {
    final db = await _database;
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    final staleBefore = now - staleSyncingAfter.inMilliseconds;
    db.execute(
      '''
      UPDATE pending_ocorrencias
      SET status = ?,
          last_error = ?,
          next_attempt_at = ?,
          updated_at = ?
      WHERE status = ? AND updated_at <= ?
      ''',
      [
        PendingStatus.failed.name,
        'Sync interrompido antes de finalizar.',
        now,
        now,
        PendingStatus.syncing.name,
        staleBefore,
      ],
    );
    _notifyChanged();
  }

  Future<void> purgeSynced() async {
    final db = await _database;
    db.execute(
      'DELETE FROM pending_ocorrencias WHERE status = ?',
      [PendingStatus.synced.name],
    );
    _notifyChanged();
  }

  /// Recoloca um item em [PendingStatus.queued] zerando o contador de tentativas.
  ///
  /// Permite retry manual pelo usuário para itens em [PendingStatus.deadLetter]
  /// ou [PendingStatus.failed].
  Future<void> resetToQueued(String clientId) async {
    final db = await _database;
    db.execute(
      '''
      UPDATE pending_ocorrencias
      SET status = ?,
          attempt_count = 0,
          next_attempt_at = 0,
          last_error = NULL,
          updated_at = ?
      WHERE client_id = ?
      ''',
      [
        PendingStatus.queued.name,
        DateTime.now().millisecondsSinceEpoch,
        clientId,
      ],
    );
    _notifyChanged();
  }

  Future<void> _updateStatus(String clientId, String status) async {
    final db = await _database;
    db.execute(
      '''
      UPDATE pending_ocorrencias
      SET status = ?, updated_at = ?
      WHERE client_id = ?
      ''',
      [status, DateTime.now().millisecondsSinceEpoch, clientId],
    );
    _notifyChanged();
  }

  Future<List<PendingOcorrencia>> _pendingRows() async {
    final db = await _database;
    // Inclui deadLetter para que a UI possa exibir e oferecer retry manual.
    final rows = db.select(
      '''
      SELECT * FROM pending_ocorrencias
      WHERE status != ?
      ORDER BY created_at ASC
      ''',
      [PendingStatus.synced.name],
    );
    return rows.map(_fromRow).toList(growable: false);
  }

  PendingOcorrencia _fromRow(Row row) {
    return PendingOcorrencia(
      clientId: row['client_id'] as String,
      payloadJson: row['payload_json'] as String,
      attachmentsJson: row['attachments_json'] as String,
      status: row['status'] as String,
      attemptCount: row['attempt_count'] as int,
      nextAttemptAt: row['next_attempt_at'] as int,
      lastError: row['last_error'] as String?,
      createdAt: row['created_at'] as int,
      updatedAt: row['updated_at'] as int,
    );
  }

  /// Exponential backoff com jitter aditivo (full-jitter pattern).
  ///
  /// base = min(2^attempt, 300) segundos
  /// jitter = random(0, base)
  /// resultado = base + jitter
  ///
  /// Evita thundering-herd quando múltiplos clientes falham simultaneamente.
  Duration _backoffFor(int attemptCount, {int? jitterSeedMs}) {
    final baseSecs = math.min(1 << attemptCount, 300);
    final rng = math.Random(jitterSeedMs);
    final jitterSecs = rng.nextInt(baseSecs + 1);
    return Duration(seconds: baseSecs + jitterSecs);
  }

  void _notifyChanged() {
    if (!_changes.isClosed) {
      _changes.add(null);
    }
  }
}

extension _RowsX on ResultSet {
  Row? get firstOrNull => isEmpty ? null : first;
}
