part of 'home_view.dart';

extension _HomeViewActions on _HomeViewState {
  Future<void> _loadPreferences() async {
    final alertMapEnabled = await _preferences.loadAlertMapEnabled();
    if (!mounted) {
      return;
    }

    if (alertMapEnabled != null) {
      context.read<HomeCubit>().setAlertMapEnabled(alertMapEnabled);
    }

    setState(() => _didLoadPreferences = true);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (!_pinReadiness.isMapReady) {
      setState(_pinReadiness.markMapReady);
    }
  }

  void _onPinsReady(String pinsKey) {
    if (!mounted ||
        (_pinReadiness.readyPinsKey == pinsKey &&
            _pinReadiness.arePinsReady)) {
      return;
    }

    setState(() => _pinReadiness.markPinsReady(pinsKey));
  }

  void _onCameraIdle(LatLngBounds bounds, double zoom) {
    context.read<HomeCubit>().onCameraIdle(bounds, zoom);
  }

  void _updateCameraQuery(String value) {
    setState(() {
      _filters = _filters.copyWith(streetQuery: value);
      _markPinsDirty(setStateAlreadyCalled: true);
    });
  }

  void _updateAlertQuery(String value) {
    setState(() {
      _filters = _filters.copyWith(alertQuery: value);
      _markPinsDirty(setStateAlreadyCalled: true);
    });
  }

  void _clearCameraFilters() {
    _streetSearchController.clear();
    setState(() {
      _filters = _filters.copyWith(
        streetQuery: '',
        selectedBairro: null,
        selectedCidade: null,
        selectedRegiao: null,
      );
      _markPinsDirty(setStateAlreadyCalled: true);
    });
  }

  void _clearAlertFilters() {
    _alertSearchController.clear();
    setState(() {
      _filters = _filters.copyWith(
        alertQuery: '',
        selectedAlertBairro: null,
        selectedAlertCidade: null,
        selectedAlertDateKey: null,
        selectedAlertTipo: null,
      );
      _markPinsDirty(setStateAlreadyCalled: true);
    });
    // Limpa também o filtro de domínio no cubit
    context.read<HomeCubit>().clearFilter();
  }

  Future<void> _openCameraFilters(List<Camera> cameras) async {
    final result = await showHomeCameraFilters(
      context: context,
      cameras: cameras,
      filters: _filters,
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _filters = _filters.copyWith(
        selectedBairro: result.bairro,
        selectedCidade: result.cidade,
        selectedRegiao: result.regiao,
      );
      _markPinsDirty(setStateAlreadyCalled: true);
    });
  }

  Future<void> _openAlertFilters(List<Alerta> alertas) async {
    final result = await showHomeAlertFilters(
      context: context,
      alertas: alertas,
      filters: _filters,
    );

    if (!mounted || result == null) {
      return;
    }

    // Atualiza filtros de UI (bairro, cidade, dateKey para texto)
    setState(() {
      _filters = _filters.copyWith(
        selectedAlertBairro: result.bairro,
        selectedAlertCidade: result.cidade,
        selectedAlertDateKey: result.dateKey,
        selectedAlertTipo: result.tipo,
      );
      _markPinsDirty(setStateAlreadyCalled: true);
    });

    // Atualiza o filtro de domínio no cubit (tipo + date range)
    // O tipo do sheet é mapeado para Set<AlertaTipo> no AlertaFilter.
    final dateFrom = _parseDateFrom(result.dateKey);
    final dateTo = _parseDateTo(result.dateKey);
    context.read<HomeCubit>().updateFilter(
          AlertaFilter(
            tipos: result.tipo != null ? {result.tipo!} : const {},
            dateFrom: dateFrom,
            dateTo: dateTo,
          ),
        );
  }

  Future<void> _goToCurrentLocation() async {
    await goToCurrentLocation(context: context, controller: _mapController);
  }

  Future<bool> _retryMapOcorrencia(Alerta alerta) async {
    final clientId = alerta.clientId;
    if (clientId == null || clientId.trim().isEmpty) {
      return false;
    }

    final didStartRetry =
        await context.read<HomeCubit>().retryOcorrencia(clientId.trim());
    if (!mounted) {
      return didStartRetry;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          didStartRetry
              ? 'Tentando enviar novamente'
              : 'Não foi possível tentar novamente agora',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
    return didStartRetry;
  }

  void _markPinsDirty({bool setStateAlreadyCalled = false}) {
    if (setStateAlreadyCalled) {
      _pinReadiness.markDirty();
      return;
    }

    setState(_pinReadiness.markDirty);
  }

  // ---------------------------------------------------------------------------
  // Helpers de conversão de dateKey (formato 'YYYY-MM-DD') → DateTime
  // ---------------------------------------------------------------------------

  /// 'YYYY-MM-DD' → início do dia
  DateTime? _parseDateFrom(String? dateKey) {
    if (dateKey == null || dateKey.isEmpty) return null;
    final parts = dateKey.split('-');
    if (parts.length != 3) return null;
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (year == null || month == null || day == null) return null;
    return DateTime(year, month, day);
  }

  /// 'YYYY-MM-DD' → fim do dia (mesmo dia)
  DateTime? _parseDateTo(String? dateKey) => _parseDateFrom(dateKey);
}
