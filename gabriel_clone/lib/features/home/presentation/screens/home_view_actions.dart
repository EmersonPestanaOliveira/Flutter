part of 'home_view.dart';

// ignore_for_file: invalid_use_of_protected_member

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
        (_pinReadiness.readyPinsKey == pinsKey && _pinReadiness.arePinsReady)) {
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
        selectedAlertPeriodo: null,
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

    // Atualiza filtros de UI (bairro, cidade, período)
    setState(() {
      _filters = _filters.copyWith(
        selectedAlertBairro: result.bairro,
        selectedAlertCidade: result.cidade,
        selectedAlertPeriodo: result.periodo,
        selectedAlertTipo: result.tipo,
      );
      _markPinsDirty(setStateAlreadyCalled: true);
    });

    // Converte o período selecionado em intervalo de datas para o AlertaFilter.
    final dateFrom = result.periodo?.dateFrom;
    final dateTo = result.periodo != null ? DateTime.now() : null;
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

    final didStartRetry = await context.read<HomeCubit>().retryOcorrencia(
      clientId.trim(),
    );
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
}
