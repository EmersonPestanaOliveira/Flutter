import 'dart:async';
import 'dart:math' as math;

import 'app_database_models.dart';

class AppDatabase {
  AppDatabase() : pendingOcorrenciasDao = PendingOcorrenciasDao();

  AppDatabase.forTesting(Object? _)
      : pendingOcorrenciasDao = PendingOcorrenciasDao();

  final PendingOcorrenciasDao pendingOcorrenciasDao;
}

class PendingOcorrenciasDao {
  PendingOcorrenciasDao();

  PendingOcorrenciasDao.forTesting(Object? _);

  static const int maxAttempts = 5;
  static const Duration staleSyncingAfter = Duration(minutes: 10);

  final Map<String, PendingOcorrencia> _items = {};
  final _changes = StreamController<void>.broadcast();

  Stream<List<PendingOcorrencia>> watchPending() async* {
    yield _pendingRows();
    await for (final _ in _changes.stream) {
      yield _pendingRows();
    }
  }

  Future<List<PendingOcorrencia>> getPendingForSync() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await resetStaleSyncing(nowMs: now);
    final rows = _items.values
        .where(
          (item) =>
              (item.status == PendingStatus.queued.name ||
                  item.status == PendingStatus.failed.name) &&
              item.attemptCount < maxAttempts &&
              item.nextAttemptAt <= now,
        )
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return rows;
  }

  Future<void> enqueue(PendingOcorrenciasCompanion entry) async {
    final existing = _items[entry.clientId];
    _items[entry.clientId] = entry.toPendingOcorrencia().copyWith(
          createdAt: existing?.createdAt,
        );
    _notifyChanged();
  }

  Future<void> markSyncing(String clientId) async {
    _updateStatus(clientId, PendingStatus.syncing.name);
  }

  Future<void> markSynced(String clientId) async {
    _updateStatus(clientId, PendingStatus.synced.name);
  }

  Future<void> markFailed(String clientId, String error) async {
    final item = _items[clientId];
    if (item == null) return;

    final nextAttemptCount = item.attemptCount + 1;
    final isDeadLetter = nextAttemptCount >= maxAttempts;
    final nextAttemptAt = isDeadLetter
        ? 0
        : DateTime.now()
            .add(_backoffFor(nextAttemptCount))
            .millisecondsSinceEpoch;

    _items[clientId] = item.copyWith(
      status: isDeadLetter
          ? PendingStatus.deadLetter.name
          : PendingStatus.failed.name,
      attemptCount: nextAttemptCount,
      nextAttemptAt: nextAttemptAt,
      lastError: error,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    _notifyChanged();
  }

  Future<void> resetStaleSyncing({int? nowMs}) async {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    final staleBefore = now - staleSyncingAfter.inMilliseconds;
    for (final entry in _items.entries.toList()) {
      final item = entry.value;
      if (item.status == PendingStatus.syncing.name &&
          item.updatedAt <= staleBefore) {
        _items[entry.key] = item.copyWith(
          status: PendingStatus.failed.name,
          lastError: 'Sync interrompido antes de finalizar.',
          nextAttemptAt: now,
          updatedAt: now,
        );
      }
    }
    _notifyChanged();
  }

  Future<void> purgeSynced() async {
    _items.removeWhere((_, item) => item.status == PendingStatus.synced.name);
    _notifyChanged();
  }

  Future<void> resetToQueued(String clientId) async {
    final item = _items[clientId];
    if (item == null) return;
    _items[clientId] = item.copyWith(
      status: PendingStatus.queued.name,
      attemptCount: 0,
      nextAttemptAt: 0,
      lastError: null,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    _notifyChanged();
  }

  List<PendingOcorrencia> _pendingRows() {
    final rows = _items.values
        .where((item) => item.status != PendingStatus.synced.name)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return rows;
  }

  void _updateStatus(String clientId, String status) {
    final item = _items[clientId];
    if (item == null) return;
    _items[clientId] = item.copyWith(
      status: status,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    _notifyChanged();
  }

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
