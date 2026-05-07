import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/design_system/components/app_error_widget.dart';
import '../../../../core/design_system/components/app_loading_indicator.dart';
import '../../domain/entities/alerta.dart';
import '../../domain/entities/camera.dart';
import '../cubit/home_state.dart';
import 'home_help_button.dart';
import 'home_map.dart';
import 'home_map_buttons.dart';
import 'home_map_search.dart';
import 'home_top_controls.dart';

class HomeMapContent extends StatelessWidget {
  const HomeMapContent({
    required this.state,
    required this.loadedState,
    required this.cameras,
    required this.alertas,
    required this.canRenderPins,
    required this.showLoading,
    required this.horizontalPadding,
    required this.bottomPadding,
    required this.topPadding,
    required this.streetSearchController,
    required this.alertSearchController,
    required this.hasActiveCameraFilters,
    required this.hasActiveAlertFilters,
    required this.onMapCreated,
    this.onCameraIdle,
    required this.onPinsReady,
    required this.onMenuPressed,
    required this.onCameraSearchChanged,
    required this.onAlertSearchChanged,
    required this.onClearCameraFilters,
    required this.onClearAlertFilters,
    required this.onCameraFiltersPressed,
    required this.onAlertFiltersPressed,
    required this.onCurrentLocationPressed,
    required this.onHelpPressed,
    required this.onRetry,
    super.key,
  });

  final HomeState state;
  final HomeLoaded? loadedState;
  final List<Camera> cameras;
  final List<Alerta> alertas;
  final bool canRenderPins;
  final bool showLoading;
  final double horizontalPadding;
  final double bottomPadding;
  final double topPadding;
  final TextEditingController streetSearchController;
  final TextEditingController alertSearchController;
  final bool hasActiveCameraFilters;
  final bool hasActiveAlertFilters;
  final ValueChanged<GoogleMapController> onMapCreated;
  final void Function(LatLngBounds bounds, double zoom)? onCameraIdle;
  final VoidCallback? onPinsReady;
  final VoidCallback onMenuPressed;
  final ValueChanged<String> onCameraSearchChanged;
  final ValueChanged<String> onAlertSearchChanged;
  final VoidCallback onClearCameraFilters;
  final VoidCallback onClearAlertFilters;
  final VoidCallback onCameraFiltersPressed;
  final VoidCallback onAlertFiltersPressed;
  final VoidCallback onCurrentLocationPressed;
  final VoidCallback onHelpPressed;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: _buildMap()),
        HomeTopControls(
          state: loadedState,
          horizontalPadding: horizontalPadding,
          topPadding: topPadding,
          hasActiveCameraFilters: hasActiveCameraFilters,
          hasActiveAlertFilters: hasActiveAlertFilters,
          onMenuPressed: onMenuPressed,
          onCameraFiltersPressed: onCameraFiltersPressed,
          onAlertFiltersPressed: onAlertFiltersPressed,
        ),
        if (loadedState?.tabIndex == 0) _buildCameraSearch(),
        if (loadedState?.tabIndex == 1) _buildAlertSearch(),
        Positioned(
          left: horizontalPadding,
          bottom: bottomPadding + 118,
          child: MapCircleButton(
            icon: Icons.my_location,
            onPressed: onCurrentLocationPressed,
          ),
        ),
        Positioned(
          right: horizontalPadding,
          bottom: bottomPadding + 80,
          child: HomeHelpButton(onPressed: onHelpPressed),
        ),
        if (showLoading) const Positioned.fill(child: AppLoadingIndicator()),
        if (state is HomeError)
          Positioned.fill(
            child: AppErrorWidget(
              message: (state as HomeError).message,
              onRetry: onRetry,
            ),
          ),
      ],
    );
  }

  Widget _buildMap() {
    return HomeMap(
      cameras: canRenderPins ? cameras : const [],
      alertas: canRenderPins && (loadedState?.isAlertMapEnabled ?? false)
          ? alertas
          : const [],
      dangerZoneAlertas: canRenderPins
          ? loadedState?.alertas ?? const []
          : const [],
      tabIndex: canRenderPins ? loadedState?.tabIndex ?? 0 : 0,
      onMapCreated: onMapCreated,
      onCameraIdle: onCameraIdle,
      onPinsReady: onPinsReady,
    );
  }

  Widget _buildCameraSearch() {
    return Positioned(
      top: topPadding + 88,
      left: horizontalPadding,
      right: horizontalPadding,
      child: MapSearchAndFilters(
        controller: streetSearchController,
        hintText: 'Pesquisar câmeras por Bairro',
        hasActiveFilters: hasActiveCameraFilters,
        onSearchChanged: onCameraSearchChanged,
        onClear: onClearCameraFilters,
      ),
    );
  }

  Widget _buildAlertSearch() {
    return Positioned(
      top: topPadding + 88,
      left: horizontalPadding,
      right: horizontalPadding,
      child: MapSearchAndFilters(
        controller: alertSearchController,
        hintText: 'Pesquisar alertas por bairro, cidade ou tipo',
        hasActiveFilters: hasActiveAlertFilters,
        onSearchChanged: onAlertSearchChanged,
        onClear: onClearAlertFilters,
      ),
    );
  }
}
