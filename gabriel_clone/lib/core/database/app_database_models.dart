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

  PendingOcorrencia copyWith({
    String? payloadJson,
    String? attachmentsJson,
    String? status,
    int? attemptCount,
    int? nextAttemptAt,
    Object? lastError = _sentinel,
    int? createdAt,
    int? updatedAt,
  }) {
    return PendingOcorrencia(
      clientId: clientId,
      payloadJson: payloadJson ?? this.payloadJson,
      attachmentsJson: attachmentsJson ?? this.attachmentsJson,
      status: status ?? this.status,
      attemptCount: attemptCount ?? this.attemptCount,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      lastError: lastError == _sentinel ? this.lastError : lastError as String?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
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

  PendingOcorrencia toPendingOcorrencia() {
    return PendingOcorrencia(
      clientId: clientId,
      payloadJson: payloadJson,
      attachmentsJson: attachmentsJson,
      status: status,
      attemptCount: attemptCount,
      nextAttemptAt: nextAttemptAt,
      lastError: lastError,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

const _sentinel = Object();
