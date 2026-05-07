import '../../../../core/database/app_database.dart';
import '../entities/ocorrencia_report.dart';
import '../repositories/ocorrencia_repository.dart';

/// Escuta as ocorrências remotas do usuário autenticado.
///
/// Retorna entidades de domínio [OcorrenciaReport] — sem tipos do Firestore.
class WatchMyOcorrenciasUseCase {
  const WatchMyOcorrenciasUseCase(this._repository);

  final OcorrenciaRepository _repository;

  Stream<List<OcorrenciaReport>> call() {
    return _repository.watchMyOcorrencias();
  }
}

/// Escuta as ocorrências pendentes de sync na fila local (SQLite).
class WatchPendingOcorrenciasUseCase {
  const WatchPendingOcorrenciasUseCase(this._repository);

  final OcorrenciaRepository _repository;

  Stream<List<PendingOcorrencia>> call() {
    return _repository.watchPending();
  }
}

/// Recoloca um item na fila para retry manual.
class RetryFailedOcorrenciaUseCase {
  const RetryFailedOcorrenciaUseCase(this._repository);

  final OcorrenciaRepository _repository;

  Future<void> call(String clientId) {
    return _repository.retryFailed(clientId);
  }
}
