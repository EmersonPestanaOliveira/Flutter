import 'package:equatable/equatable.dart';

import '../../domain/entities/alerta.dart';
import '../../domain/entities/alerta_cluster.dart';
import '../../domain/entities/alerta_filter.dart';
import '../../domain/entities/camera.dart';
import '../../domain/services/alerta_cluster_service.dart';
import '../utils/home_filter_utils.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.cameras,
    required this.alertas,
    this.tabIndex = 0,
    this.isAlertMapEnabled = true,
    this.filter = const AlertaFilter(),
    this.currentZoom = 13.0,
    this.selectedAlerta,
    this.isLoadingPins = false,
    this.showMapUpdateIndicator = false,
    this.incrementalErrorMessage,
  });

  final List<Camera> cameras;

  /// Lista completa de alertas no viewport atual.
  final List<Alerta> alertas;

  final int tabIndex;
  final bool isAlertMapEnabled;
  final AlertaFilter filter;
  final double currentZoom;

  /// Alerta selecionado ao tocar num pin individual.
  final Alerta? selectedAlerta;

  /// `true` enquanto uma query de viewport está em andamento.
  final bool isLoadingPins;
  final bool showMapUpdateIndicator;
  final String? incrementalErrorMessage;

  /// Alertas filtrados pelos critérios ativos (pura função).
  List<Alerta> get filteredAlertas => applyFilter(alertas, filter);

  /// Clusters calculados para o zoom atual — determinístico e testável.
  AlertaClusterResult get clusterResult =>
      AlertaClusterService.build(filteredAlertas, currentZoom);

  List<AlertaCluster> get clusters => clusterResult.clusters;

  HomeLoaded copyWith({
    List<Camera>? cameras,
    List<Alerta>? alertas,
    int? tabIndex,
    bool? isAlertMapEnabled,
    AlertaFilter? filter,
    double? currentZoom,
    Object? selectedAlerta = _sentinel,
    bool? isLoadingPins,
    bool? showMapUpdateIndicator,
    Object? incrementalErrorMessage = _sentinel,
  }) {
    return HomeLoaded(
      cameras: cameras ?? this.cameras,
      alertas: alertas ?? this.alertas,
      tabIndex: tabIndex ?? this.tabIndex,
      isAlertMapEnabled: isAlertMapEnabled ?? this.isAlertMapEnabled,
      filter: filter ?? this.filter,
      currentZoom: currentZoom ?? this.currentZoom,
      selectedAlerta:
          selectedAlerta == _sentinel ? this.selectedAlerta : selectedAlerta as Alerta?,
      isLoadingPins: isLoadingPins ?? this.isLoadingPins,
      showMapUpdateIndicator:
          showMapUpdateIndicator ?? this.showMapUpdateIndicator,
      incrementalErrorMessage: incrementalErrorMessage == _sentinel
          ? this.incrementalErrorMessage
          : incrementalErrorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
        cameras,
        alertas,
        tabIndex,
        isAlertMapEnabled,
        filter,
        currentZoom,
        selectedAlerta,
        isLoadingPins,
        showMapUpdateIndicator,
        incrementalErrorMessage,
      ];
}

final class HomeError extends HomeState {
  const HomeError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

const _sentinel = Object();
