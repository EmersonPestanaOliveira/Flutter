import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/ocorrencias/data/datasources/ocorrencia_local_datasource.dart';
import '../../features/ocorrencias/data/datasources/ocorrencia_remote_datasource.dart';
import '../../features/ocorrencias/data/services/ocorrencia_service.dart';
import '../database/app_database.dart';
import '../observability/telemetry.dart';
import '../security/attachment_storage.dart';

/// Classifica um erro como recuperável ou permanente.
///
/// Erros recuperáveis → retry com backoff exponencial + jitter.
/// Erros permanentes → deadLetter imediato (sem mais tentativas automáticas).
bool isRecoverableSyncError(Object error) {
  final msg = error.toString().toLowerCase();
  if (error is SocketException) return true;
  if (msg.contains('network') ||
      msg.contains('timeout') ||
      msg.contains('connection') ||
      msg.contains('unavailable') ||
      msg.contains('socket') ||
      msg.contains('offline')) {
    return true;
  }
  // Erros de auth/dados inválidos são permanentes
  if (msg.contains('unauthenticated') ||
      msg.contains('permission-denied') ||
      msg.contains('invalid-argument')) {
    return false;
  }
  // Default: recuperável para não perder dados do usuário
  return true;
}

/// Sincroniza ocorrências pendentes no SQLite com Firestore/Storage.
///
/// Estratégias implementadas:
/// - Backoff com jitter (full-jitter) para evitar thundering-herd.
/// - Diferenciação entre erros recuperáveis e permanentes.
/// - Limpeza de attachments locais após sync confirmado (somente após markSynced).
/// - Recuperação automática de itens travados em `syncing` por timeout (10 min).
/// - Telemetria detalhada sem dados sensíveis.
class OcorrenciaSyncWorker {
  const OcorrenciaSyncWorker({
    required OcorrenciaLocalDatasource local,
    required OcorrenciaRemoteDatasource remote,
    required Telemetry telemetry,
    AttachmentStorage? attachmentStorage,
  }) : _local = local,
       _remote = remote,
       _telemetry = telemetry,
       _attachmentStorage = attachmentStorage;

  final OcorrenciaLocalDatasource _local;
  final OcorrenciaRemoteDatasource _remote;
  final Telemetry _telemetry;
  final AttachmentStorage? _attachmentStorage;

  Future<SyncResult> syncPendingOcorrencias() async {
    return _telemetry.trace('sync_ocorrencias', () async {
      await _local.resetStaleSyncing();
      final pending = await _local.getPendingForSync();

      if (pending.isEmpty) {
        debugPrint('[SyncWorker] Nenhum item pendente.');
        return const SyncResult(total: 0, success: 0, failed: 0);
      }

      _telemetry.log(
        'sync.started',
        params: {
          'total': pending.length,
          ..._queueMetrics(pending),
        },
      );
      debugPrint('[SyncWorker] Processando ${pending.length} item(s).');

      var success = 0;
      var failed = 0;

      for (final item in pending) {
        final ok = await _syncItem(item);
        if (ok) {
          success++;
        } else {
          failed++;
        }
      }

      _telemetry.log(
        'sync.finished',
        params: {
          'total': pending.length,
          'success': success,
          'failed': failed,
          'successRatePct': pending.isEmpty ? 100 : (success * 100) ~/ pending.length,
        },
      );
      debugPrint('[SyncWorker] Resultado: $success ok / $failed falhou.');
      return SyncResult(
        total: pending.length,
        success: success,
        failed: failed,
      );
    });
  }

  Future<bool> _syncItem(PendingOcorrencia item) async {
    final startMs = DateTime.now().millisecondsSinceEpoch;
    try {
      await _local.markSyncing(item.clientId);

      _telemetry.log(
        'sync.item_started',
        params: {
          'clientId': _safeId(item.clientId),
          'attempt': item.attemptCount + 1,
        },
      );

      await _remote.createOcorrencia(
        clientId: item.clientId,
        input: _deserializeInput(item),
      );
      await _local.markSynced(item.clientId);

      // Limpeza segura: só remove após confirmação de sync
      await _cleanupAttachments(item.clientId);

      final elapsed = DateTime.now().millisecondsSinceEpoch - startMs;
      _telemetry.log(
        'sync.item_success',
        params: {
          'clientId': _safeId(item.clientId),
          'elapsedMs': elapsed,
          'attempt': item.attemptCount + 1,
          'timeInQueueMs': startMs - item.createdAt,
        },
      );

      debugPrint('[SyncWorker] Sincronizado: ${_safeId(item.clientId)}');
      return true;
    } catch (e, st) {
      final isRecoverable = isRecoverableSyncError(e);
      debugPrint(
        '[SyncWorker] Falhou (${_safeId(item.clientId)}), '
        'recuperável=$isRecoverable: ${e.runtimeType}',
      );

      // Registra tipo de erro sem dados sensíveis (sem toString do payload)
      _telemetry.recordError(
        SyncItemError(
          clientId: _safeId(item.clientId),
          attempt: item.attemptCount + 1,
          isRecoverable: isRecoverable,
          originalType: e.runtimeType.toString(),
        ),
        st,
        reason: 'ocorrencia_sync',
      );

      _telemetry.log(
        'sync.item_failed',
        params: {
          'clientId': _safeId(item.clientId),
          'attempt': item.attemptCount + 1,
          'isRecoverable': isRecoverable,
          'errorType': e.runtimeType.toString(),
          'retryCount': item.attemptCount,
        },
      );

      if (!isRecoverable) {
        // Força deadLetter para erros permanentes: avança attempts até maxAttempts
        var attempts = item.attemptCount;
        while (attempts < PendingOcorrenciasDao.maxAttempts) {
          await _local.markFailed(
            item.clientId,
            '[permanent:${e.runtimeType}]',
          );
          attempts++;
        }
      } else {
        await _local.markFailed(item.clientId, e.runtimeType.toString());
      }

      return false;
    }
  }

  /// Sanitiza o clientId para logs — mostra apenas os primeiros 8 chars.
  /// Nenhuma PII ou dado sensível é logado.
  String _safeId(String clientId) =>
      clientId.length > 8 ? '${clientId.substring(0, 8)}…' : clientId;

  /// Remove os arquivos locais de attachment após sync confirmado.
  ///
  /// SEGURANÇA: chamado SOMENTE após [markSynced] confirmar sucesso.
  /// Enquanto o item ainda não estiver sincronizado, os arquivos são preservados.
  Future<void> _cleanupAttachments(String clientId) async {
    try {
      final storage = _attachmentStorage;
      if (storage != null) {
        await storage.cleanup(clientId);
      } else {
        final docsDir = await getApplicationDocumentsDirectory();
        final attachDir = Directory('${docsDir.path}/ocorrencias/$clientId');
        if (await attachDir.exists()) {
          await attachDir.delete(recursive: true);
        }
      }
      _telemetry.log(
        'sync.attachments_cleaned',
        params: {'clientId': _safeId(clientId)},
      );
    } catch (e) {
      // Limpeza não é crítica — não propaga, apenas loga
      debugPrint('[SyncWorker] Falha ao limpar attachments: ${e.runtimeType}');
    }
  }

  CreateOcorrenciaInput _deserializeInput(PendingOcorrencia item) {
    final payload = jsonDecode(item.payloadJson) as Map<String, dynamic>;
    final attachmentsList =
        (jsonDecode(item.attachmentsJson) as List<dynamic>)
            .cast<Map<String, dynamic>>();

    OcorrenciaAttachment? audio;
    OcorrenciaAttachment? boletim;
    final multimidia = <OcorrenciaAttachment>[];

    for (final attachment in attachmentsList) {
      final parsed = OcorrenciaAttachment(
        path: attachment['path'] as String,
        storageName: attachment['storageName'] as String,
        kind: attachment['kind'] as String,
      );
      switch (parsed.kind) {
        case 'audio':
          audio = parsed;
        case 'documento':
          boletim = parsed;
        default:
          multimidia.add(parsed);
      }
    }

    return CreateOcorrenciaInput(
      informacoes: payload['informacoes'] as String,
      quando: DateTime.parse(payload['quando'] as String),
      horario: payload['horario'] as String,
      latitude: (payload['latitude'] as num).toDouble(),
      longitude: (payload['longitude'] as num).toDouble(),
      enderecoBusca: payload['enderecoBusca'] as String,
      cienteBoletim: payload['cienteBoletim'] as bool,
      aceitePrivacidade: payload['aceitePrivacidade'] as bool,
      audio: audio,
      boletimOcorrencia: boletim,
      multimidia: multimidia,
    );
  }

  Map<String, Object?> _queueMetrics(List<PendingOcorrencia> items) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final ages = items.map((item) => now - item.createdAt).toList();
    return {
      'queueSize': items.length,
      'avgAgeMs': ages.isEmpty ? 0 : ages.reduce((a, b) => a + b) ~/ ages.length,
      'maxAgeMs': ages.isEmpty ? 0 : ages.reduce((a, b) => a > b ? a : b),
      'retryCount': items.fold<int>(0, (sum, item) => sum + item.attemptCount),
      'deadLetter': items
          .where((item) => item.status == PendingStatus.deadLetter.name)
          .length,
    };
  }
}

/// Erro estruturado para telemetria — sem dados sensíveis do usuário.
class SyncItemError {
  const SyncItemError({
    required this.clientId,
    required this.attempt,
    required this.isRecoverable,
    required this.originalType,
  });

  /// Apenas os primeiros 8 chars do clientId (não é PII).
  final String clientId;
  final int attempt;
  final bool isRecoverable;
  final String originalType;

  @override
  String toString() =>
      'SyncItemError(id=$clientId, attempt=$attempt, '
      'recoverable=$isRecoverable, type=$originalType)';
}

class SyncResult {
  const SyncResult({
    required this.total,
    required this.success,
    required this.failed,
  });

  final int total;
  final int success;
  final int failed;

  @override
  String toString() =>
      'SyncResult(total: $total, success: $success, failed: $failed)';
}
