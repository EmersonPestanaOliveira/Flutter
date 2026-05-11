import '../../domain/entities/alerta.dart';
import '../../domain/entities/camera.dart';
import '../cubit/home_state.dart';
import '../utils/home_filter_utils.dart';
import 'home_filter_state.dart';

class HomeViewData {
  const HomeViewData({
    required this.loadedState,
    required this.cameras,
    required this.alertas,
    required this.pinsKey,
  });

  final HomeLoaded? loadedState;
  final List<Camera> cameras;
  final List<Alerta> alertas;
  final String? pinsKey;
}

HomeViewData buildHomeViewData(HomeState state, HomeFilterState filters) {
  final loadedState = state is HomeLoaded ? state : null;
  final cameras = _filteredCameras(loadedState, filters);
  final alertas = _filteredAlertas(loadedState, filters);
  final pinsKey = loadedState == null
      ? null
      : homePinsKey(state: loadedState, cameras: cameras, alertas: alertas);

  return HomeViewData(
    loadedState: loadedState,
    cameras: cameras,
    alertas: alertas,
    pinsKey: pinsKey,
  );
}

List<Camera> _filteredCameras(HomeLoaded? state, HomeFilterState filters) {
  if (state == null) {
    return const <Camera>[];
  }
  return applyCameraFilters(
    state.cameras,
    query: filters.streetQuery,
    bairro: filters.selectedBairro,
    cidade: filters.selectedCidade,
    regiao: filters.selectedRegiao,
  );
}

List<Alerta> _filteredAlertas(HomeLoaded? state, HomeFilterState filters) {
  if (state == null) {
    return const <Alerta>[];
  }
  // Parte 1: filtro de domínio (tipo / data) já aplicado em state.filteredAlertas.
  // Parte 2: filtros de UI (texto, bairro, cidade) aplicados aqui na camada de apresentação.
  return applyAlertFilters(
    state.filteredAlertas,
    query: filters.alertQuery,
    bairro: filters.selectedAlertBairro,
    cidade: filters.selectedAlertCidade,
    tipo: filters.selectedAlertTipo,
  );
}
