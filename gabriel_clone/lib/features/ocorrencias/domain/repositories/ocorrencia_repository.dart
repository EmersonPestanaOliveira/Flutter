import '../../../../core/database/app_database.dart';
import '../../../../core/types/app_result.dart';
import '../../data/services/ocorrencia_service.dart';
import '../entities/ocorrencia_report.dart';

/// Contrato de domínio para ocorrências.
///
/// REGRA: nenhum tipo do Firebase/Firestore pode aparecer nesta interface.
/// O repositório retorna entidades de domínio, não QuerySnapshots.
abstract interface class OcorrenciaRepository {
  /// Salva localmente e retorna o [clientId] imediatamente (UX otimista).
  /// Dispara sync em background se estiver online.
  Future<AppResult<String>> create(CreateOcorrenciaInput input);

  /// Stream reativo das ocorrências remotas do usuário autenticado.
  ///
  /// Retorna entidades de domínio [OcorrenciaReport] — sem tipos do Firestore.
  Stream<List<OcorrenciaReport>> watchMyOcorrencias();

  /// Stream reativo das ocorrências pendentes de sync (SQLite).
  Stream<List<PendingOcorrencia>> watchPending();

  /// Recoloca um item em [PendingStatus.queued] para ser reprocessado.
  ///
  /// Usado pelo botão "tentar novamente" na tela "Meus Relatos".
  Future<void> retryFailed(String clientId);
}
