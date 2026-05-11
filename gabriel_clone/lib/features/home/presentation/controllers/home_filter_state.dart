import '../../domain/enums/alerta_tipo.dart';
import '../widgets/alert_filters_sheet.dart';

class HomeFilterState {
  const HomeFilterState({
    this.streetQuery = '',
    this.selectedBairro,
    this.selectedCidade,
    this.selectedRegiao,
    this.alertQuery = '',
    this.selectedAlertBairro,
    this.selectedAlertCidade,
    this.selectedAlertPeriodo,
    this.selectedAlertTipo,
  });

  final String streetQuery;
  final String? selectedBairro;
  final String? selectedCidade;
  final String? selectedRegiao;
  final String alertQuery;
  final String? selectedAlertBairro;
  final String? selectedAlertCidade;
  final AlertPeriodo? selectedAlertPeriodo;
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
      selectedAlertPeriodo != null ||
      selectedAlertTipo != null;

  HomeFilterState copyWith({
    String? streetQuery,
    Object? selectedBairro = _sentinel,
    Object? selectedCidade = _sentinel,
    Object? selectedRegiao = _sentinel,
    String? alertQuery,
    Object? selectedAlertBairro = _sentinel,
    Object? selectedAlertCidade = _sentinel,
    Object? selectedAlertPeriodo = _sentinel,
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
      selectedAlertPeriodo: selectedAlertPeriodo == _sentinel
          ? this.selectedAlertPeriodo
          : selectedAlertPeriodo as AlertPeriodo?,
      selectedAlertTipo: selectedAlertTipo == _sentinel
          ? this.selectedAlertTipo
          : selectedAlertTipo as AlertaTipo?,
    );
  }
}

const _sentinel = Object();
