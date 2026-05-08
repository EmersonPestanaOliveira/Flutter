import '../entities/alerta.dart';

class AlertaPinMergeResult {
  const AlertaPinMergeResult({
    required this.alertas,
    required this.remoteCount,
    required this.localCount,
    required this.deduplicatedCount,
  });

  final List<Alerta> alertas;
  final int remoteCount;
  final int localCount;
  final int deduplicatedCount;
}

abstract final class AlertaPinMergeService {
  static AlertaPinMergeResult merge({
    required List<Alerta> remoteAlertas,
    required List<Alerta> localAlertas,
  }) {
    final byKey = <String, Alerta>{};
    var deduplicated = 0;

    for (final remote in remoteAlertas) {
      byKey[remote.mergeKey] = remote;
    }

    for (final local in localAlertas) {
      final key = local.mergeKey;
      final existing = byKey[key];
      if (existing != null) {
        deduplicated++;
      }

      if (_localShouldWin(local, existing)) {
        byKey[key] = local;
      }
    }

    return AlertaPinMergeResult(
      alertas: byKey.values.toList(growable: false),
      remoteCount: remoteAlertas.length,
      localCount: localAlertas.length,
      deduplicatedCount: deduplicated,
    );
  }

  static bool _localShouldWin(Alerta local, Alerta? remote) {
    if (remote == null) return true;

    return switch (local.localSyncStatus) {
      'queued' => true,
      'syncing' => true,
      'failed' => true,
      'deadLetter' => true,
      // `synced` is only an optimistic bridge. Once remote exists, use remote.
      _ => false,
    };
  }
}
