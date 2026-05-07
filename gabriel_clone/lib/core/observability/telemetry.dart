import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';

/// Camada de observabilidade centralizada.
///
/// Eventos padronizados (usar sempre as constantes em [TelemetryEvents]):
///
/// ### Mapa
/// - map.initial_load         — primeiros pins carregados
/// - map.viewport_loaded      — pins carregados para viewport
/// - map.viewport_query_failed— falha na query de viewport
/// - map.filter_applied       — filtro ativado
/// - map.pin_tapped           — usuário tocou em pin
/// - map.cluster_tapped       — usuário tocou em cluster
/// - map.icon_cache_hit       — BitmapDescriptor carregado do cache
/// - map.icon_cache_miss      — BitmapDescriptor criado (cache miss)
///
/// ### Sync / Offline
/// - ocorrencia.created_offline     — criada localmente
/// - ocorrencia.sync_immediate_success — sync fire-and-forget ok
/// - sync.started                   — worker iniciou
/// - sync.finished                  — worker terminou
/// - sync.item_started              — item iniciando sync
/// - sync.item_success              — item sincronizado
/// - sync.item_failed               — item falhou
/// - sync.attachments_cleaned       — attachments removidos após sync
///
/// ### UX / Formulário
/// - form.submit_started        — botão enviar pressionado
/// - form.submit_success        — salvo localmente com sucesso
/// - form.submit_failed         — erro ao salvar
/// - form.audio_started         — gravação iniciada
/// - form.audio_recorded        — gravação concluída
/// - form.media_added           — mídia adicionada
///
/// SEGURANÇA: nenhum dado do usuário (nome, email, conteúdo de relato)
/// deve ser incluído nos parâmetros de log. Apenas metadados técnicos.
class Telemetry {
  const Telemetry({
    FirebaseCrashlytics? crashlytics,
    FirebasePerformance? performance,
  }) : _crashlytics = crashlytics,
       _performance = performance;

  final FirebaseCrashlytics? _crashlytics;
  final FirebasePerformance? _performance;

  FirebaseCrashlytics get _crash =>
      _crashlytics ?? FirebaseCrashlytics.instance;

  FirebasePerformance get _perf =>
      _performance ?? FirebasePerformance.instance;

  /// Inicia uma trace de performance Firebase e executa [body].
  ///
  /// Use para medir operações com impacto visível no usuário:
  /// carregamento do mapa, sync de fila, upload de attachment.
  Future<T> trace<T>(
    String name,
    Future<T> Function() body, {
    Map<String, String> attributes = const {},
    Map<String, int> metrics = const {},
  }) async {
    final trace = _perf.newTrace(name);
    for (final entry in attributes.entries) {
      trace.putAttribute(entry.key, entry.value);
    }
    for (final entry in metrics.entries) {
      trace.setMetric(entry.key, entry.value);
    }
    await trace.start();
    try {
      final result = await body();
      return result;
    } finally {
      await trace.stop();
    }
  }

  /// Registra um evento de domínio no Crashlytics breadcrumb.
  ///
  /// REGRA: [params] nunca deve conter dados pessoais ou conteúdo do usuário.
  void log(String event, {Map<String, Object?> params = const {}}) {
    if (kDebugMode) {
      debugPrint('[Telemetry] $event $params');
    }
    // Crashlytics.log aceita no máximo 64kB de breadcrumbs
    _crash.log('$event ${_sanitizeParams(params)}');
  }

  /// Registra um erro técnico. Não use para erros com dados do usuário.
  void recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  }) {
    if (kDebugMode) {
      debugPrint('[Telemetry] ERROR [$reason]: $error');
    }
    _crash.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: fatal,
      printDetails: kDebugMode,
    );
  }

  /// Sanitiza parâmetros para garantir que nenhum dado sensível seja logado.
  /// Remove chaves e valores que possam conter PII.
  Map<String, Object?> _sanitizeParams(Map<String, Object?> params) {
    const _blocklist = {'email', 'name', 'phone', 'address', 'content', 'text'};
    return {
      for (final e in params.entries)
        if (!_blocklist.contains(e.key.toLowerCase()))
          e.key: e.value,
    };
  }
}

/// Constantes de nomes de eventos para evitar typos e facilitar busca.
abstract final class TelemetryEvents {
  // Mapa
  static const mapInitialLoad = 'map.initial_load';
  static const mapViewportLoaded = 'map.viewport_loaded';
  static const mapViewportFailed = 'map.viewport_query_failed';
  static const mapFilterApplied = 'map.filter_applied';
  static const mapPinTapped = 'map.pin_tapped';
  static const mapClusterTapped = 'map.cluster_tapped';
  static const mapIconCacheHit = 'map.icon_cache_hit';
  static const mapIconCacheMiss = 'map.icon_cache_miss';

  // Sync / Offline
  static const ocorrenciaCreatedOffline = 'ocorrencia.created_offline';
  static const ocorrenciaSyncSuccess = 'ocorrencia.sync_immediate_success';
  static const syncStarted = 'sync.started';
  static const syncFinished = 'sync.finished';
  static const syncItemStarted = 'sync.item_started';
  static const syncItemSuccess = 'sync.item_success';
  static const syncItemFailed = 'sync.item_failed';
  static const syncAttachmentsCleaned = 'sync.attachments_cleaned';

  // UX / Formulário
  static const formSubmitStarted = 'form.submit_started';
  static const formSubmitSuccess = 'form.submit_success';
  static const formSubmitFailed = 'form.submit_failed';
  static const formAudioStarted = 'form.audio_started';
  static const formAudioRecorded = 'form.audio_recorded';
  static const formMediaAdded = 'form.media_added';
}
