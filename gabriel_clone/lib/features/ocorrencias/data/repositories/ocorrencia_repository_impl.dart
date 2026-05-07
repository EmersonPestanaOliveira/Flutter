import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_connection_monitor.dart';
import '../../../../core/observability/telemetry.dart';
import '../../../../core/security/attachment_storage.dart';
import '../../../../core/types/app_result.dart';
import '../../data/datasources/ocorrencia_local_datasource.dart';
import '../../data/datasources/ocorrencia_remote_datasource.dart';
import '../../data/models/ocorrencia_report_model.dart';
import '../../data/services/ocorrencia_service.dart';
import '../../domain/entities/ocorrencia_report.dart';
import '../../domain/repositories/ocorrencia_repository.dart';

class OcorrenciaRepositoryImpl implements OcorrenciaRepository {
  OcorrenciaRepositoryImpl({
    required OcorrenciaLocalDatasource local,
    required OcorrenciaRemoteDatasource remote,
    required NetworkConnectionMonitor network,
    required Telemetry telemetry,
    required AttachmentStorage attachmentStorage,
    Uuid? uuid,
    OcorrenciaService? service,
  }) : _local = local,
       _remote = remote,
       _network = network,
       _telemetry = telemetry,
       _attachmentStorage = attachmentStorage,
       _uuid = uuid ?? const Uuid(),
       _service = service ?? OcorrenciaService();

  final OcorrenciaLocalDatasource _local;
  final OcorrenciaRemoteDatasource _remote;
  final NetworkConnectionMonitor _network;
  final Telemetry _telemetry;
  final AttachmentStorage _attachmentStorage;
  final Uuid _uuid;
  final OcorrenciaService _service;

  @override
  Future<AppResult<String>> create(CreateOcorrenciaInput input) async {
    try {
      final clientId = _uuid.v4();
      final now = DateTime.now().millisecondsSinceEpoch;

      // 1. Copiar attachments para diretório persistente (sobrevive ao restart)
      final persistedAttachments = await _persistAttachments(clientId, input);

      // 2. Serializar payload textual/numérico separado dos paths de attachment
      final payloadJson = jsonEncode(_inputToPayload(input));
      final attachmentsJson = jsonEncode(persistedAttachments);

      // 3. Enfileirar no SQLite com status=queued
      await _local.enqueue(
        PendingOcorrenciasCompanion(
          clientId: clientId,
          payloadJson: payloadJson,
          attachmentsJson: attachmentsJson,
          status: PendingStatus.queued.name,
          attemptCount: 0,
          nextAttemptAt: 0,
          createdAt: now,
          updatedAt: now,
        ),
      );

      _telemetry.log(
        'ocorrencia.created_offline',
        params: {'clientId': clientId},
      );

      // 4. Retornar sucesso imediatamente (UX otimista)
      // 5. Disparar tentativa de sync fire-and-forget se online
      final isOnline = _network.status == NetworkConnectionStatus.online;
      if (isOnline) {
        unawaited(_trySyncOne(clientId, input, persistedAttachments));
      }

      return Right(clientId);
    } catch (e) {
      return Left(UnknownFailure(log: e));
    }
  }

  @override
  Stream<List<OcorrenciaReport>> watchMyOcorrencias() {
    // Mapeia o Stream do Firestore para entidades de domínio.
    // Nenhum tipo do Firestore vaza para além desta camada de dados.
    return _service.watchMyOcorrencias().map(
      (snapshot) => snapshot.docs
          .map(OcorrenciaReportModel.fromFirestore)
          .toList(growable: false),
    );
  }

  @override
  Stream<List<PendingOcorrencia>> watchPending() {
    return _local.watchPending();
  }

  @override
  Future<void> retryFailed(String clientId) {
    return _local.resetToQueued(clientId);
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Copia todos os arquivos de attachment do diretório temporário para o
  /// diretório de documentos do app, garantindo que persistam entre sessões.
  Future<List<Map<String, dynamic>>> _persistAttachments(
    String clientId,
    CreateOcorrenciaInput input,
  ) async {
    final List<Map<String, dynamic>> result = [];

    if (input.audio != null) {
      final dest = await _attachmentStorage.persist(
        input.audio!.path,
        clientId,
        'audio',
      );
      result.add({
        'path': dest,
        'storageName': input.audio!.storageName,
        'kind': input.audio!.kind,
      });
    }

    if (input.boletimOcorrencia != null) {
      final dest = await _attachmentStorage.persist(
        input.boletimOcorrencia!.path,
        clientId,
        'boletim',
      );
      result.add({
        'path': dest,
        'storageName': input.boletimOcorrencia!.storageName,
        'kind': input.boletimOcorrencia!.kind,
      });
    }

    for (final media in input.multimidia) {
      final dest = await _attachmentStorage.persist(
        media.path,
        clientId,
        'multimidia',
      );
      result.add({
        'path': dest,
        'storageName': media.storageName,
        'kind': media.kind,
      });
    }

    return result;
  }

  Map<String, dynamic> _inputToPayload(CreateOcorrenciaInput input) {
    return {
      'informacoes': input.informacoes,
      'quando': input.quando.toIso8601String(),
      'horario': input.horario,
      'latitude': input.latitude,
      'longitude': input.longitude,
      'enderecoBusca': input.enderecoBusca,
      'cienteBoletim': input.cienteBoletim,
      'aceitePrivacidade': input.aceitePrivacidade,
    };
  }

  /// Tenta sincronizar um item logo após a criação (fire-and-forget).
  Future<void> _trySyncOne(
    String clientId,
    CreateOcorrenciaInput input,
    List<Map<String, dynamic>> attachments,
  ) async {
    try {
      await _local.markSyncing(clientId);
      final rebuiltInput = _rebuildInput(input, attachments);
      await _remote.createOcorrencia(clientId: clientId, input: rebuiltInput);
      await _local.markSynced(clientId);
      await _attachmentStorage.cleanup(clientId);
      _telemetry.log(
        'ocorrencia.sync_immediate_success',
        params: {'clientId': clientId},
      );
    } catch (e) {
      await _local.markFailed(clientId, e.toString());
      debugPrint('[OcorrenciaRepo] Sync imediato falhou para $clientId: $e');
    }
  }

  /// Remove os arquivos locais de um clientId após sync bem-sucedido.
  ///
  /// SEGURANÇA: só é chamado após [markSynced] confirmar sucesso.
  Future<void> _cleanupAttachments(String clientId) async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final attachDir = Directory('${docsDir.path}/ocorrencias/$clientId');
      if (await attachDir.exists()) {
        await attachDir.delete(recursive: true);
        debugPrint('[OcorrenciaRepo] Attachments removidos para $clientId');
      }
    } catch (e) {
      // Limpeza falhou — não crítico, não propaga
      debugPrint('[OcorrenciaRepo] Falha ao limpar attachments $clientId: $e');
    }
  }

  /// Reconstrói o [CreateOcorrenciaInput] com os paths persistidos.
  CreateOcorrenciaInput _rebuildInput(
    CreateOcorrenciaInput original,
    List<Map<String, dynamic>> attachments,
  ) {
    OcorrenciaAttachment? audio;
    OcorrenciaAttachment? boletim;
    final List<OcorrenciaAttachment> multimidia = [];

    for (final a in attachments) {
      final att = OcorrenciaAttachment(
        path: a['path'] as String,
        storageName: a['storageName'] as String,
        kind: a['kind'] as String,
      );
      switch (att.kind) {
        case 'audio':
          audio = att;
        case 'documento':
          boletim = att;
        default:
          multimidia.add(att);
      }
    }

    return CreateOcorrenciaInput(
      informacoes: original.informacoes,
      quando: original.quando,
      horario: original.horario,
      latitude: original.latitude,
      longitude: original.longitude,
      enderecoBusca: original.enderecoBusca,
      cienteBoletim: original.cienteBoletim,
      aceitePrivacidade: original.aceitePrivacidade,
      audio: audio,
      boletimOcorrencia: boletim,
      multimidia: multimidia,
    );
  }
}
