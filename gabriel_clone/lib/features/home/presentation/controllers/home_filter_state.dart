import '../../domain/enums/alerta_tipo.dart';

class HomeFilterState {
  const HomeFilterState({
    this.streetQuery = '',
    this.selectedBairro,
    this.selectedCidade,
    this.selectedRegiao,
    this.alertQuery = '',
    this.selectedAlertBairro,
    this.selectedAlertCidade,
    this.selectedAlertDateKey,
    this.selectedAlertTipo,
  });

  final String streetQuery;
  final String? selectedBairro;
  final String? selectedCidade;
  final String? selectedRegiao;
  final String alertQuery;
  final String? selectedAlertBairro;
  final String? selectedAlertCidade;
  final String? selectedAlertDateKey;
  final AlertaTipo? selectedAlertTipo;

  bool get hasActiveCameraFilters =>
      streetQuery.trim().isNotEmpty ||
      selectedBairro != null ||
      selectedCidade != null ||
      selectedRegiao != null;

  bool get hasActiveAlertFilters =>
      alertQuery.trim().isNotEmpty ||
      selectedAlertBairro != null ||
      selectedAlertCidade != null ||
      selectedAlertDateKey != null ||
      selectedAlertTipo != null;

  HomeFilterState copyWith({
    String? streetQuery,
    Object? selectedBairro = _sentinel,
    Object? selectedCidade = _sentinel,
    Object? selectedRegiao = _sentinel,
    String? alertQuery,
    Object? selectedAlertBairro = _sentinel,
    Object? selectedAlertCidade = _sentinel,
    Object? selectedAlertDateKey = _sentinel,
    Object? selectedAlertTipo = _sentinel,
  }) {
    return HomeFilterState(
      streetQuery: streetQuery ?? this.streetQuery,
      selectedBairro: selectedBairro == _sentinel
          ? this.selectedBairro
          : selectedBairro as String?,
      selectedCidade: selectedCidade == _sentinel
          ? this.selectedCidade
          : selectedCidade as String?,
      selectedRegiao: selectedRegiao == _sentinel
          ? this.selectedRegiao
          : selectedRegiao as String?,
      alertQuery: alertQuery ?? this.alertQuery,
      selectedAlertBairro: selectedAlertBairro == _sentinel
          ? this.selectedAlertBairro
          : selectedAlertBairro as String?,
      selectedAlertCidade: selectedAlertCidade == _sentinel
          ? this.selectedAlertCidade
          : selectedAlertCidade as String?,
      selectedAlertDateKey: selectedAlertDateKey == _sentinel
          ? this.selectedAlertDateKey
          : selectedAlertDateKey as String?,
      selectedAlertTipo: selectedAlertTipo == _sentinel
          ? this.selectedAlertTipo
          : selectedAlertTipo as AlertaTipo?,
    );
  }
}

const _sentinel = Object();
