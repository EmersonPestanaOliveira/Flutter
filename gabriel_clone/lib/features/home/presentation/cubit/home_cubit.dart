import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/errors/failure_x.dart';
import '../../../../core/geo/geo_utils.dart';
import '../../../../core/observability/telemetry.dart';
import '../../../../core/types/app_result.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/database/app_database.dart';
import '../../../ocorrencias/data/datasources/ocorrencia_local_datasource.dart';
import '../../domain/entities/alerta.dart';
import '../../domain/entities/alerta_filter.dart';
import '../../domain/entities/camera.dart';
import '../../domain/enums/alerta_tipo.dart';
import '../../domain/usecases/get_alertas_in_bounds_usecase.dart';
import '../../domain/usecases/get_alertas_usecase.dart';
import '../../domain/usecases/get_cameras_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this.getCamerasUseCase,
    this.getAlertasUseCase,
    this.getAlertasInBoundsUseCase,
    {
      Telemetry? telemetry,
      OcorrenciaLocalDatasource? localOcorrencias,
    },
  )  : _telemetry = telemetry,
        _localOcorrencias = localOcorrencias,
        super(const HomeInitial());

  final GetCamerasUseCase getCamerasUseCase;
  final GetAlertasUseCase getAlertasUseCase;
  final GetAlertasInBoundsUseCase getAlertasInBoundsUseCase;
  final Telemetry? _telemetry;
  final OcorrenciaLocalDatasource? _localOcorrencias;

  bool _initialAlertMapEnabled = true;
  Timer? _cameraIdleDebounce;
  StreamSubscription<List<PendingOcorrencia>>? _pendingSubscription;
  List<Alerta> _localPendingAlertas = const [];

  // Cache para evitar re-fetch com mesmo bounds+zoom+filter
  GeoBounds? _lastBounds;
  double? _lastZoom;
  AlertaFilter? _lastFilter;
  LatLngBounds? _currentViewport;
  double? _currentViewportZoom;

  Future<void> loadData() async {
    _watchLocalPendingAlertas();
    emit(const HomeLoading());
    final loadStart = DateTime.now().millisecondsSinceEpoch;

    final results = await Future.wait([
      getCamerasUseCase(const NoParams()),
      getAlertasUseCase(const NoParams()),
    ]);

    final camerasResult = results[0] as AppResult<List<Camera>>;
    final alertasResult = results[1] as AppResult<List<Alerta>>;

    final cameras = camerasResult.fold<List<Camera>?>(
      (failure) {
        emit(HomeError(message: failure.message));
        return null;
      },
      (data) => data,
    );

    if (cameras == null) return;

    final alertas = alertasResult.fold<List<Alerta>>(
      (failure) {
        if (kDebugMode) {
          debugPrint('[HomeCubit] Falha ao carregar alertas: ${failure.message}');
        }
        return const <Alerta>[];
      },
      (data) => data,
    );

    final elapsed = DateTime.now().millisecondsSinceEpoch - loadStart;
    _telemetry?.log(
      'map.initial_load',
      params: {
        'pinCount': alertas.length,
        'elapsedMs': elapsed,
      },
    );

    emit(
      HomeLoaded(
        cameras: cameras,
        alertas: _mergeLocalPending(alertas),
        isAlertMapEnabled: _initialAlertMapEnabled,
      ),
    );
  }

  void _watchLocalPendingAlertas() {
    if (_pendingSubscription != null) return;
    final local = _localOcorrencias;
    if (local == null) return;

    _pendingSubscription = local.watchPending().listen((items) {
      _localPendingAlertas = items
          .map(_pendingToAlerta)
          .whereType<Alerta>()
          .toList(growable: false);
      final currentState = state;
      if (currentState is HomeLoaded) {
        emit(currentState.copyWith(
          alertas: _mergeLocalPending(currentState.alertas),
        ));
      }
      _telemetry?.log(
        'offline.queue_snapshot',
        params: _queueMetrics(items),
      );
    });
  }

  List<Alerta> _mergeLocalPending(List<Alerta> remoteAlertas) {
    if (_localPendingAlertas.isEmpty) return remoteAlertas;
    final remoteOnly =
        remoteAlertas.where((alerta) => !alerta.isLocalPending).toList();
    final remoteIds = remoteOnly.map((alerta) => alerta.id).toSet();
    final localOnly = _localPendingAlertas
        .where((alerta) => !remoteIds.contains(alerta.id))
        .toList(growable: false);
    return [...remoteOnly, ...localOnly];
  }

  Alerta? _pendingToAlerta(PendingOcorrencia item) {
    try {
      final payload = jsonDecode(item.payloadJson) as Map<String, dynamic>;
      return Alerta(
        id: item.clientId,
        bairro: '',
        cidade: '',
        data: DateTime.tryParse(payload['quando'] as String? ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(item.createdAt),
        descricao: 'Relato comunitario',
        tipo: AlertaTipo.outros,
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
      unawaited(_fetchInBounds(bounds, zoom, force: true));
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
      () => _fetchInBounds(bounds, zoom),
    );
  }

  Future<void> _fetchInBounds(
    LatLngBounds bounds,
    double zoom, {
    bool force = false,
  }) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    final geoBounds = GeoBounds(
      south: bounds.southwest.latitude,
      west: bounds.southwest.longitude,
      north: bounds.northeast.latitude,
      east: bounds.northeast.longitude,
    );

    // Cache hit: mesmos bounds, zoom e filtro → não re-busca
    if (_lastBounds != null &&
        _lastZoom != null &&
        _lastFilter != null &&
        _boundsEqual(geoBounds, _lastBounds!) &&
        (zoom - _lastZoom!).abs() < 0.5 &&
        currentState.filter == _lastFilter &&
        !force) {
      // Atualiza apenas o zoom para re-clusterizar
      if (currentState.currentZoom != zoom) {
        emit(currentState.copyWith(currentZoom: zoom));
      }
      return;
    }

    emit(currentState.copyWith(isLoadingPins: true, currentZoom: zoom));

    final loadStart = DateTime.now().millisecondsSinceEpoch;
    final result = await getAlertasInBoundsUseCase(
      GetAlertasInBoundsParams(
        bounds: bounds,
        zoom: zoom,
        filter: currentState.filter,
      ),
    );

    result.fold(
      (failure) {
        if (kDebugMode) {
          debugPrint('[HomeCubit] Falha na query por bounds: ${failure.message}');
        }
        _telemetry?.log('map.viewport_query_failed');
        final latestState = state;
        if (latestState is HomeLoaded) {
          emit(latestState.copyWith(isLoadingPins: false));
        }
      },
      (alertas) {
        final mergedAlertas = _mergeLocalPending(alertas);
        final elapsed = DateTime.now().millisecondsSinceEpoch - loadStart;
        final clusterStart = DateTime.now().millisecondsSinceEpoch;
        final clusterCount = currentState
            .copyWith(alertas: mergedAlertas, currentZoom: zoom)
            .clusters
            .length;
        final clusterElapsed =
            DateTime.now().millisecondsSinceEpoch - clusterStart;
        _lastBounds = geoBounds;
        _lastZoom = zoom;
        _lastFilter = currentState.filter;

        _telemetry?.log(
          'map.viewport_loaded',
          params: {
            'zoom': zoom.toStringAsFixed(1),
            'pinCount': mergedAlertas.length,
            'remotePinCount': alertas.length,
            'localPendingPinCount': _localPendingAlertas.length,
            'elapsedMs': elapsed,
            'clusterCount': clusterCount,
            'clusterElapsedMs': clusterElapsed,
          },
        );
        final latestState = state;
        if (latestState is HomeLoaded) {
          emit(latestState.copyWith(
            alertas: mergedAlertas,
            currentZoom: zoom,
            isLoadingPins: false,
          ));
        }
      },
    );
  }

  bool _boundsEqual(GeoBounds a, GeoBounds b) {
    const epsilon = 0.001;
    return (a.south - b.south).abs() < epsilon &&
        (a.north - b.north).abs() < epsilon &&
        (a.west - b.west).abs() < epsilon &&
        (a.east - b.east).abs() < epsilon;
  }

  @override
  Future<void> close() {
    _cameraIdleDebounce?.cancel();
    _pendingSubscription?.cancel();
    return super.close();
  }
}
