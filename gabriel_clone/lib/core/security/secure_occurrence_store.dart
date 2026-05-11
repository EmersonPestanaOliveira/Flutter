import '../database/app_database.dart';
import 'local_payload_crypto.dart';

/// Fachada de alto nível para armazenamento seguro de ocorrências locais.
///
/// Combina [PendingOcorrenciasDao] + [LocalPayloadCrypto] + [AttachmentStorage]
/// em uma única interface coesa.
///
/// ## Responsabilidades
///
/// - Criptografar o payload antes de persistir.
/// - Descriptografar ao ler.
/// - Delegar ao DAO para operações de fila.
///
///
/// Quando [LocalPayloadCrypto] for implementado com AES-GCM, esta classe
/// não precisará mudar — apenas a injeção de dependência muda no DI container.
class SecureOccurrenceStore {
  const SecureOccurrenceStore({
    required PendingOcorrenciasDao dao,
    required LocalPayloadCrypto crypto,
  }) : _dao = dao,
       _crypto = crypto;

  final PendingOcorrenciasDao _dao;
  final LocalPayloadCrypto _crypto;

  /// Enfileira uma ocorrência com payload criptografado.
  Future<void> enqueue(PendingOcorrenciasCompanion entry) async {
    final encryptedPayload = await _crypto.encrypt(entry.payloadJson);
    await _dao.enqueue(
      PendingOcorrenciasCompanion(
        clientId: entry.clientId,
        payloadJson: encryptedPayload,
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

  /// Retorna os itens pendentes com payload descriptografado.
  Future<List<PendingOcorrencia>> getPendingForSync() async {
    final items = await _dao.getPendingForSync();
    return Future.wait(items.map(_decryptItem));
  }

  Future<PendingOcorrencia> _decryptItem(PendingOcorrencia item) async {
    final decryptedPayload = await _crypto.decrypt(item.payloadJson);
    return PendingOcorrencia(
      clientId: item.clientId,
      payloadJson: decryptedPayload,
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
