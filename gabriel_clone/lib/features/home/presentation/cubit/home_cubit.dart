import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/geo/geo_utils.dart';
import '../../../../core/observability/telemetry.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../ocorrencias/data/datasources/ocorrencia_local_datasource.dart';
import '../../../ocorrencias/domain/usecases/watch_my_ocorrencias_usecase.dart';
import '../../data/services/stress_pins_config_service.dart';
import '../../domain/entities/alerta.dart';
import '../../domain/entities/alerta_filter.dart';
import '../../domain/entities/camera.dart';
import '../../domain/enums/alerta_tipo.dart';
import '../../domain/services/alerta_pin_merge_service.dart';
import '../../domain/services/stress_pins_generator.dart';
import '../../domain/usecases/get_alertas_in_bounds_usecase.dart';
import '../../domain/usecases/get_alertas_usecase.dart';
import '../../domain/usecases/get_cameras_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this.getCamerasUseCase,
    this.getAlertasUseCase,
    this.getAlertasInBoundsUseCase, {
    Telemetry? telemetry,
    OcorrenciaLocalDatasource? localOcorrencias,
    RetryFailedOcorrenciaUseCase? retryFailedOcorrenciaUseCase,
    StressPinsConfigService? stressPinsConfigService,
    StressPinsGenerator? stressPinsGenerator,
  })  : _telemetry = telemetry,
        _localOcorrencias = localOcorrencias,
        _retryFailedOcorrenciaUseCase = retryFailedOcorrenciaUseCase,
        _stressPinsConfigService = stressPinsConfigService,
        _stressPinsGenerator = stressPinsGenerator ?? const StressPinsGenerator(),
        super(const HomeInitial());

  final GetCamerasUseCase getCamerasUseCase;
  final GetAlertasUseCase getAlertasUseCase;
  final GetAlertasInBoundsUseCase getAlertasInBoundsUseCase;
  final Telemetry? _telemetry;
  final OcorrenciaLocalDatasource? _localOcorrencias;
  final RetryFailedOcorrenciaUseCase? _retryFailedOcorrenciaUseCase;
  final StressPinsConfigService? _stressPinsConfigService;
  final StressPinsGenerator _stressPinsGenerator;

  bool _initialAlertMapEnabled = true;
  Timer? _cameraIdleDebounce;
  Timer? _mapUpdateIndicatorTimer;
  Timer? _incrementalErrorTimer;
  StreamSubscription<List<PendingOcorrencia>>? _pendingSubscription;
  List<Alerta> _localPendingAlertas = const [];
  final Map<String, Alerta> _recentlySyncedAlertas = {};
  final Map<String, Timer> _recentlySyncedTimers = {};
  Map<String, Alerta> _lastLocalAlertasByKey = const {};
  int _viewportQuerySeq = 0;

  /// Pins remotos acumulados ao longo da sessao (chave = `mergeKey`).
  ///
  /// Cada query por viewport adiciona/atualiza entradas; nada e removido a
  /// menos que o filtro mude. Isso garante que pins ja carregados nao
  /// "sumem" quando o usuario faz pan e a query nova retorna so o novo
  /// recorte do mapa — o resultado em tela e a uniao dos viewports visitados.
  final Map<String, Alerta> _accumulatedRemote = {};

  /// Buffer aplicado ao viewport antes de consultar pins.
  ///
  /// Carregamos uma area maior do que a visivel para que pan/zoom curtos
  /// nao disparem nova query (o usuario ja tem os pins do "anel" externo
  /// pre-carregados em memoria) e os pins nao "piscam" ao rolar o mapa.
  ///
  /// Razao 0.5 = 50% extra em cada lado → area 2.25x do viewport visivel.
  static const double _viewportBufferRatio = 0.5;

  // Cache do bounds JA EXPANDIDO usado na ultima query, para detectar
  // quando o viewport corrente ainda esta totalmente coberto.
  GeoBounds? _lastExpandedBounds;
  double? _lastZoom;
  AlertaFilter? _lastFilter;
  LatLngBounds? _currentViewport;
  double? _currentViewportZoom;

  Future<void> loadData() async {
    _watchLocalPendingAlertas();
    emit(const HomeLoading());
    final loadStart = DateTime.now().millisecondsSinceEpoch;

    final camerasResult = await getCamerasUseCase(const NoParams());

    final cameras = camerasResult.fold<List<Camera>?>(
      (failure) {
        emit(HomeError(message: failure.message));
        return null;
      },
      (data) => data,
    );

    if (cameras == null) return;

    final stressAlertas = await _loadStressPinsIfEnabled();

    final elapsed = DateTime.now().millisecondsSinceEpoch - loadStart;
    _telemetry?.log(
      'map.initial_load',
      params: {
        'pinCount': stressAlertas.length,
        'stressPinCount': stressAlertas.length,
        'elapsedMs': elapsed,
        'usesViewportLoading': true,
      },
    );

    // Popula acumulador para que viewport-fetches subsequentes apenas
    // adicionem pins novos em vez de descartar os ja carregados.
    _accumulatedRemote.clear();
    for (final alerta in stressAlertas) {
      _accumulatedRemote[alerta.mergeKey] = alerta;
    }
    // Marca o filtro inicial sob o qual o acumulador foi construido. Se o
    // usuario aplicar um filtro depois, _fetchInBounds detecta a mudanca e
    // descarta as entradas antigas que nao casam mais.
    _lastFilter = const AlertaFilter();

    emit(
      HomeLoaded(
        cameras: cameras,
        alertas: _mergePins().alertas,
        isAlertMapEnabled: _initialAlertMapEnabled,
      ),
    );
  }

  Future<List<Alerta>> _loadStressPinsIfEnabled() async {
    final configService = _stressPinsConfigService;
    if (configService == null) return const [];

    final config = await configService.loadConfig();
    if (!config.enabled || config.count <= 0) return const [];

    final generated = _stressPinsGenerator.generateSaoPauloPins(
      count: config.count,
    );
    _telemetry?.log(
      'map.stress_pins_enabled',
      params: {'pinCount': generated.length},
    );
    if (kDebugMode) {
      debugPrint('[StressPins] Gerados ${generated.length} pins em Sao Paulo.');
    }
    return generated;
  }

  void _watchLocalPendingAlertas() {
    if (_pendingSubscription != null) return;
    final local = _localOcorrencias;
    if (local == null) return;

    _pendingSubscription = local.watchPending().listen((items) {
      final nextLocalAlertas = items
          .map(_pendingToAlerta)
          .whereType<Alerta>()
          .toList(growable: false);
      _bridgeRecentlySyncedPins(nextLocalAlertas);
      _localPendingAlertas = nextLocalAlertas;
      _lastLocalAlertasByKey = {
        for (final alerta in nextLocalAlertas) alerta.mergeKey: alerta,
      };
      final currentState = state;
      if (currentState is HomeLoaded) {
        emit(currentState.copyWith(
          alertas: _mergePins().alertas,
        ));
      }
      _telemetry?.log(
        'offline.queue_snapshot',
        params: _queueMetrics(items),
      );
    });
  }

  /// Mescla os pins remotos acumulados com os locais (pendentes + recem
  /// sincronizados que ainda estao no bridge de transicao).
  AlertaPinMergeResult _mergePins() {
    return AlertaPinMergeService.merge(
      remoteAlertas: _accumulatedRemote.values.toList(growable: false),
      localAlertas: [
        ..._recentlySyncedAlertas.values,
        ..._localPendingAlertas,
      ],
    );
  }

  void _bridgeRecentlySyncedPins(List<Alerta> nextLocalAlertas) {
    final nextKeys = nextLocalAlertas.map((alerta) => alerta.mergeKey).toSet();
    for (final entry in _lastLocalAlertasByKey.entries) {
      if (nextKeys.contains(entry.key)) continue;
      final previous = entry.value;
      final status = previous.localSyncStatus;
      if (status == PendingStatus.syncing.name ||
          status == PendingStatus.queued.name) {
        _recentlySyncedAlertas[entry.key] = previous.copyWith(
          localSyncStatus: PendingStatus.synced.name,
          localError: null,
        );
        _recentlySyncedTimers[entry.key]?.cancel();
        _recentlySyncedTimers[entry.key] = Timer(
          const Duration(seconds: 20),
          () {
            if (isClosed) return;
            _recentlySyncedAlertas.remove(entry.key);
            _recentlySyncedTimers.remove(entry.key);
            final currentState = state;
            if (currentState is HomeLoaded) {
              emit(currentState.copyWith(alertas: _mergePins().alertas));
            }
          },
        );
      }
    }
  }

  Alerta? _pendingToAlerta(PendingOcorrencia item) {
    try {
      final payload = jsonDecode(item.payloadJson) as Map<String, dynamic>;
      final categoriaName = payload['categoria'] as String? ?? '';
      final tipo = AlertaTipo.values.firstWhere(
        (t) => t.name == categoriaName,
        orElse: () => alertaTipoFromString(categoriaName),
      );
      return Alerta(
        id: item.clientId,
        clientId: item.clientId,
        bairro: '',
        cidade: '',
        data: DateTime.tryParse(payload['quando'] as String? ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(item.createdAt),
        descricao: 'Relato comunitario',
        tipo: tipo,
        latitude: (payload['latitude'] as num).toDouble(),
        longitude: (payload['longitude'] as num).toDouble(),
        localSyncStatus: item.status,
        localError: item.lastError,
      );
    } catch (_) {
      return null;
    }
  }

  Map<String, Object?> _queueMetrics(List<PendingOcorrencia> items) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final ages = items.map((item) => now - item.createdAt).toList();
    final deadLetters =
        items.where((item) => item.status == PendingStatus.deadLetter.name);
    final failures =
        items.where((item) => item.status == PendingStatus.failed.name);
    return {
      'queueSize': items.length,
      'avgAgeMs': ages.isEmpty ? 0 : ages.reduce((a, b) => a + b) ~/ ages.length,
      'maxAgeMs': ages.isEmpty ? 0 : ages.reduce((a, b) => a > b ? a : b),
      'failed': failures.length,
      'deadLetter': deadLetters.length,
      'retryCount': items.fold<int>(0, (sum, item) => sum + item.attemptCount),
    };
  }

  void changeTab(int index) {
    final currentState = state;
    if (currentState is! HomeLoaded) return;
    emit(currentState.copyWith(tabIndex: index));
  }

  void setAlertMapEnabled(bool isEnabled) {
    final currentState = state;
    if (currentState is! HomeLoaded) {
      _initialAlertMapEnabled = isEnabled;
      return;
    }
    _initialAlertMapEnabled = isEnabled;
    emit(
      currentState.copyWith(
        isAlertMapEnabled: isEnabled,
        tabIndex: isEnabled ? currentState.tabIndex : 0,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Seleção de alerta (pin individual)
  // ---------------------------------------------------------------------------

  void selectAlerta(Alerta alerta) {
    final currentState = state;
    if (currentState is! HomeLoaded) return;
    _telemetry?.log('map.pin_tapped', params: {'alertaId': alerta.id});
    emit(currentState.copyWith(selectedAlerta: alerta));
  }

  void clearSelectedAlerta() {
    final currentState = state;
    if (currentState is! HomeLoaded) return;
    emit(currentState.copyWith(selectedAlerta: null));
  }

  Future<bool> retryOcorrencia(String clientId) async {
    final useCase = _retryFailedOcorrenciaUseCase;
    final normalizedClientId = clientId.trim();
    if (useCase == null || normalizedClientId.isEmpty) {
      _telemetry?.log('map.offline_retry_unavailable', params: {
        'hasUseCase': useCase != null,
      });
      return false;
    }

    try {
      final localStatus = _localPendingAlertas
          .where((alerta) => alerta.clientId == normalizedClientId)
          .map((alerta) => alerta.localSyncStatus ?? 'unknown')
          .fold<String?>(null, (previous, value) => previous ?? value);
      _telemetry?.log('map.offline_retry_requested', params: {
        'status': localStatus,
      });
      await useCase(normalizedClientId);
      _telemetry?.log('map.offline_retry_started');

      final currentState = state;
      if (currentState is HomeLoaded) {
        final nextAlertas = currentState.alertas
            .map(
              (alerta) => alerta.clientId == normalizedClientId
                  ? alerta.copyWith(
                      localSyncStatus: PendingStatus.queued.name,
                      localError: null,
                    )
                  : alerta,
            )
            .toList(growable: false);
        emit(currentState.copyWith(alertas: nextAlertas));
      }
      return true;
    } catch (error) {
      _telemetry?.log('map.offline_retry_failed', params: {
        'errorType': error.runtimeType.toString(),
      });
      return false;
    }
  }

  void onClusterTapped(double clusterLat, double clusterLon) {
    _telemetry?.log('map.cluster_tapped');
    // A UI deve usar esta sinalização para animar o zoom
  }

  // ---------------------------------------------------------------------------
  // Filtro de domínio
  // ---------------------------------------------------------------------------

  void updateFilter(AlertaFilter filter) {
    final currentState = state;
    if (currentState is! HomeLoaded) return;
    if (currentState.filter == filter) return;
    _lastFilter = null; // Invalida cache para forçar re-fetch com novo filtro
    _telemetry?.log(
      'map.filter_applied',
      params: {
        'tipos': filter.tipos.map((t) => t.name).join(','),
        'hasDateFrom': filter.dateFrom != null,
        'hasDateTo': filter.dateTo != null,
      },
    );
    emit(currentState.copyWith(filter: filter));

    final bounds = _currentViewport;
    final zoom = _currentViewportZoom;
    if (bounds != null && zoom != null) {
      unawaited(_fetchInBounds(bounds, zoom, force: true, reason: 'filter'));
    }
  }

  void clearFilter() => updateFilter(const AlertaFilter());

  // ---------------------------------------------------------------------------
  // Viewport — onCameraIdle com debounce 300ms
  // ---------------------------------------------------------------------------

  /// Chamado pelo mapa sempre que a câmera para de se mover.
  ///
  /// - Debounce de 300ms para evitar chamadas excessivas durante o gesto.
  /// - Evita re-fetch se bounds, zoom e filtro não mudaram (cache hit).
  /// - Atualiza [currentZoom] no state para recalcular clusters.
  void onCameraIdle(LatLngBounds bounds, double zoom) {
    _currentViewport = bounds;
    _currentViewportZoom = zoom;
    _cameraIdleDebounce?.cancel();
    _cameraIdleDebounce = Timer(
      const Duration(milliseconds: 300),
      () => _fetchInBounds(bounds, zoom, reason: 'camera_idle'),
    );
  }

  Future<void> _fetchInBounds(
    LatLngBounds bounds,
    double zoom, {
    bool force = false,
    String reason = 'viewport',
  }) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    final viewportBounds = GeoBounds(
      south: bounds.southwest.latitude,
      west: bounds.southwest.longitude,
      north: bounds.northeast.latitude,
      east: bounds.northeast.longitude,
    );

    // Expande o viewport para pre-carregar um anel externo. Pan curto
    // continua dentro do bounds expandido anterior e nao dispara query.
    final expandedBounds = _expandBounds(bounds, _viewportBufferRatio);

    // Cache hit: viewport visivel ainda totalmente coberto pelo bounds
    // expandido da query anterior + zoom proximo + mesmo filtro.
    if (_lastExpandedBounds != null &&
        _lastZoom != null &&
        _lastFilter != null &&
        _isViewportInside(viewportBounds, _lastExpandedBounds!) &&
        (zoom - _lastZoom!).abs() < 0.5 &&
        currentState.filter == _lastFilter &&
        !force) {
      _telemetry?.log(
        'map.viewport_query_skipped',
        params: {
          'reason': 'covered_by_buffer',
          'zoom': zoom.toStringAsFixed(1),
        },
      );
      // Atualiza apenas o zoom para re-clusterizar
      if (currentState.currentZoom != zoom) {
        emit(currentState.copyWith(currentZoom: zoom));
      }
      return;
    }

    final queryId = ++_viewportQuerySeq;
    _telemetry?.log(
      'map.viewport_query_started',
      params: {
        'queryId': queryId,
        'reason': reason,
        'zoom': zoom.toStringAsFixed(1),
        'bufferRatio': _viewportBufferRatio,
      },
    );
    _scheduleMapUpdateIndicator(queryId);
    emit(currentState.copyWith(
      isLoadingPins: true,
      currentZoom: zoom,
      incrementalErrorMessage: null,
    ));

    final loadStart = DateTime.now().millisecondsSinceEpoch;
    final result = await getAlertasInBoundsUseCase(
      GetAlertasInBoundsParams(
        bounds: _toLatLngBounds(expandedBounds),
        zoom: zoom,
        filter: currentState.filter,
      ),
    );

    result.fold(
      (failure) {
        if (queryId != _viewportQuerySeq) {
          _telemetry?.log(
            'map.viewport_query_discarded',
            params: {'queryId': queryId, 'reason': 'failure_obsolete'},
          );
          return;
        }
        if (kDebugMode) {
          debugPrint('[HomeCubit] Falha na query por bounds: ${failure.message}');
        }
        _hideMapUpdateIndicator();
        _telemetry?.log(
          'map.viewport_query_failed',
          params: {'queryId': queryId, 'reason': reason},
        );
        final latestState = state;
        if (latestState is HomeLoaded) {
          emit(latestState.copyWith(
            isLoadingPins: false,
            showMapUpdateIndicator: false,
            incrementalErrorMessage: 'Nao foi possivel atualizar o mapa.',
          ));
          _scheduleIncrementalErrorClear();
        }
      },
      (alertas) {
        if (queryId != _viewportQuerySeq) {
          _telemetry?.log(
            'map.viewport_query_discarded',
            params: {'queryId': queryId, 'reason': 'success_obsolete'},
          );
          return;
        }
        _hideMapUpdateIndicator();

        // Filtro mudou desde a ultima query bem-sucedida → o que estava
        // acumulado pode nao casar com o filtro novo. Esvazia antes de
        // reabastecer com o novo recorte. (`_lastFilter` e populado em
        // `loadData`, entao nao precisa de null-check aqui.)
        final filterChanged = _lastFilter != currentState.filter;
        if (filterChanged) {
          _accumulatedRemote.clear();
        }

        // Mescla pins novos com os ja acumulados (chave = mergeKey).
        // Atualiza entradas existentes com os dados mais recentes do servidor.
        final addedCount = alertas.length;
        final beforeCount = _accumulatedRemote.length;
        for (final alerta in alertas) {
          _accumulatedRemote[alerta.mergeKey] = alerta;
        }
        final accumulatedDelta = _accumulatedRemote.length - beforeCount;

        final mergeResult = _mergePins();
        final mergedAlertas = mergeResult.alertas;
        final elapsed = DateTime.now().millisecondsSinceEpoch - loadStart;
        final clusterStart = DateTime.now().millisecondsSinceEpoch;
        final clusterResult = currentState
            .copyWith(alertas: mergedAlertas, currentZoom: zoom)
            .clusterResult;
        final clusterElapsed =
            DateTime.now().millisecondsSinceEpoch - clusterStart;
        _lastExpandedBounds = expandedBounds;
        _lastZoom = zoom;
        _lastFilter = currentState.filter;

        _telemetry?.log(
          'map.viewport_loaded',
          params: {
            'zoom': zoom.toStringAsFixed(1),
            'pinCount': mergedAlertas.length,
            'queryReturnedPinCount': addedCount,
            'newPinsAdded': accumulatedDelta,
            'accumulatedRemoteSize': _accumulatedRemote.length,
            'remotePinCount': mergeResult.remoteCount,
            'localMergedPinCount': mergeResult.localCount,
            'deduplicatedPinCount': mergeResult.deduplicatedCount,
            'finalRenderedPinCount': mergedAlertas.length,
            'filterChangedReset': filterChanged,
            'elapsedMs': elapsed,
            'clusteringEnabled': clusterResult.enabled,
            'clusterDecisionReason': clusterResult.reason,
            'clusterCount': clusterResult.clusterCount,
            'individualPinCount': clusterResult.individualPinCount,
            'clusterElapsedMs': clusterElapsed,
          },
        );
        final latestState = state;
        if (latestState is HomeLoaded) {
          _incrementalErrorTimer?.cancel();
          emit(latestState.copyWith(
            alertas: mergedAlertas,
            currentZoom: zoom,
            isLoadingPins: false,
            showMapUpdateIndicator: false,
            incrementalErrorMessage: null,
          ));
        }
      },
    );
  }

  void _scheduleMapUpdateIndicator(int queryId) {
    _mapUpdateIndicatorTimer?.cancel();
    _mapUpdateIndicatorTimer = Timer(const Duration(milliseconds: 320), () {
      if (isClosed) return;
      if (queryId != _viewportQuerySeq) return;
      final currentState = state;
      if (currentState is HomeLoaded && currentState.isLoadingPins) {
        emit(currentState.copyWith(showMapUpdateIndicator: true));
      }
    });
  }

  void _hideMapUpdateIndicator() {
    _mapUpdateIndicatorTimer?.cancel();
    _mapUpdateIndicatorTimer = null;
  }

  void _scheduleIncrementalErrorClear() {
    _incrementalErrorTimer?.cancel();
    _incrementalErrorTimer = Timer(const Duration(seconds: 4), () {
      if (isClosed) return;
      final currentState = state;
      if (currentState is HomeLoaded) {
        emit(currentState.copyWith(incrementalErrorMessage: null));
      }
    });
  }

  /// Expande [bounds] em [ratio] vezes em cada eixo (lat e lon).
  ///
  /// `ratio = 0.5` adiciona 50% extra em cada lado → area 2.25x do original.
  /// Pre-carregar esse "anel externo" deixa pan/zoom curtos sem nova query.
  GeoBounds _expandBounds(LatLngBounds bounds, double ratio) {
    final ne = bounds.northeast;
    final sw = bounds.southwest;
    final latSpan = ne.latitude - sw.latitude;
    final lonSpan = ne.longitude - sw.longitude;
    final dLat = latSpan * ratio;
    final dLon = lonSpan * ratio;
    return GeoBounds(
      south: math.max(sw.latitude - dLat, -90.0),
      north: math.min(ne.latitude + dLat, 90.0),
      // Para o caso de Brasil/SP nao precisamos tratar wrap em ±180.
      // Se o app for usado em rotas que cruzam o antimeridiano, ajustar.
      west: sw.longitude - dLon,
      east: ne.longitude + dLon,
    );
  }

  /// Verifica se o viewport visivel esta totalmente contido em [outer].
  ///
  /// Quando true, o resultado em cache ja cobre o que o usuario ve e nao
  /// e preciso refazer a query. Containment estrito (so [_floatEpsilon] de
  /// folga para precisao de ponto flutuante) — qualquer faixa do viewport
  /// fora de [outer] significa pins potencialmente faltantes na borda e
  /// dispara re-fetch.
  static const double _floatEpsilon = 1e-6;

  bool _isViewportInside(GeoBounds viewport, GeoBounds outer) {
    return viewport.south >= outer.south - _floatEpsilon &&
        viewport.north <= outer.north + _floatEpsilon &&
        viewport.west >= outer.west - _floatEpsilon &&
        viewport.east <= outer.east + _floatEpsilon;
  }

  /// Converte [GeoBounds] para [LatLngBounds] (sem wrap de longitude).
  LatLngBounds _toLatLngBounds(GeoBounds bounds) {
    return LatLngBounds(
      southwest: LatLng(bounds.south, bounds.west),
      northeast: LatLng(bounds.north, bounds.east),
    );
  }

  @override
  Future<void> close() {
    _cameraIdleDebounce?.cancel();
    _mapUpdateIndicatorTimer?.cancel();
    _incrementalErrorTimer?.cancel();
    _pendingSubscription?.cancel();
    for (final timer in _recentlySyncedTimers.values) {
      timer.cancel();
    }
    return super.close();
  }
}
