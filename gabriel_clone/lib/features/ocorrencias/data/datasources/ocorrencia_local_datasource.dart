import '../../../../core/database/app_database.dart';
import '../../../../core/security/local_payload_crypto.dart';

/// Wrapper sobre o DAO SQLite, sem logica de negocio.
/// Existe para desacoplar o sync worker e o repositorio da persistencia local.
abstract interface class OcorrenciaLocalDatasource {
  Stream<List<PendingOcorrencia>> watchPending();
  Future<List<PendingOcorrencia>> getPendingForSync();
  Future<void> enqueue(PendingOcorrenciasCompanion entry);
  Future<void> markSyncing(String clientId);
  Future<void> markSynced(String clientId);
  Future<void> markFailed(String clientId, String error);
  Future<void> resetStaleSyncing();
  Future<void> purgeSynced();

  /// Recoloca um item em [PendingStatus.queued] zerando o contador de tentativas.
  /// Usado para retry manual pelo usuário.
  Future<void> resetToQueued(String clientId);
}

class OcorrenciaLocalDatasourceImpl implements OcorrenciaLocalDatasource {
  OcorrenciaLocalDatasourceImpl(this._dao, this._crypto);

  final PendingOcorrenciasDao _dao;
  final LocalPayloadCrypto _crypto;

  @override
  Stream<List<PendingOcorrencia>> watchPending() {
    return _dao.watchPending().asyncMap(_decryptItems);
  }

  @override
  Future<List<PendingOcorrencia>> getPendingForSync() async {
    return _decryptItems(await _dao.getPendingForSync());
  }

  @override
  Future<void> enqueue(PendingOcorrenciasCompanion entry) async {
    await _dao.enqueue(
      PendingOcorrenciasCompanion(
        clientId: entry.clientId,
        payloadJson: await _crypto.encrypt(entry.payloadJson),
        attachmentsJson: entry.attachmentsJson,
        status: entry.status,
        attemptCount: entry.attemptCount,
        nextAttemptAt: entry.nextAttemptAt,
        lastError: entry.lastError,
        createdAt: entry.createdAt,
        updatedAt: entry.updatedAt,
      ),
    );
  }

  @override
  Future<void> markSyncing(String clientId) => _dao.markSyncing(clientId);

  @override
  Future<void> markSynced(String clientId) => _dao.markSynced(clientId);

  @override
  Future<void> markFailed(String clientId, String error) =>
      _dao.markFailed(clientId, error);

  @override
  Future<void> resetStaleSyncing() => _dao.resetStaleSyncing();

  @override
  Future<void> purgeSynced() => _dao.purgeSynced();

  @override
  Future<void> resetToQueued(String clientId) => _dao.resetToQueued(clientId);

  Future<List<PendingOcorrencia>> _decryptItems(
    List<PendingOcorrencia> items,
  ) {
    return Future.wait(items.map(_decryptItem));
  }

  Future<PendingOcorrencia> _decryptItem(PendingOcorrencia item) async {
    return PendingOcorrencia(
      clientId: item.clientId,
      payloadJson: await _crypto.decrypt(item.payloadJson),
      attachmentsJson: item.attachmentsJson,
      status: item.status,
      attemptCount: item.attemptCount,
      nextAttemptAt: item.nextAttemptAt,
      lastError: item.lastError,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
    );
  }
}
