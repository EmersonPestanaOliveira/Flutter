import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/geo/app_map_bounds.dart';
import '../../domain/entities/alerta.dart';
import 'alert_preview_card.dart';
import 'home_map_constants.dart';

class HomeMapView extends StatelessWidget {
  const HomeMapView({
    required this.tabIndex,
    required this.cameraMarkers,
    required this.alertMarkers,
    required this.dangerZoneCircles,
    required this.selectedAlert,
    required this.onAlertClose,
    required this.onAlertDeselect,
    required this.onMapCreated,
    this.onAlertRetry,
    this.onCameraMove,
    this.onCameraIdle,
    super.key,
  });

  final int tabIndex;
  final Set<Marker> cameraMarkers;
  final Set<Marker> alertMarkers;
  final Set<Circle> dangerZoneCircles;
  final Alerta? selectedAlert;
  final VoidCallback onAlertClose;
  final VoidCallback onAlertDeselect;
  final ValueChanged<GoogleMapController> onMapCreated;
  final Future<bool> Function(Alerta alerta)? onAlertRetry;
  final void Function(CameraPosition position)? onCameraMove;
  final VoidCallback? onCameraIdle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: HomeMapConstants.saoPaulo,
            zoom: HomeMapConstants.initialZoom,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          cameraTargetBounds: AppMapBounds.southeastBrazilCameraTarget,
          onTap: (_) => onAlertDeselect(),
          onMapCreated: _handleMapCreated,
          onCameraMove: onCameraMove,
          onCameraIdle: onCameraIdle,
          markers: tabIndex == 0 ? cameraMarkers : alertMarkers,
          circles: tabIndex == 1 ? dangerZoneCircles : const <Circle>{},
        ),
        if (tabIndex == 1 && selectedAlert != null)
          Positioned(
            left: 32,
            right: 32,
            bottom: MediaQuery.paddingOf(context).bottom + 112,
            child: AlertPreviewCard(
              alerta: selectedAlert!,
              onClose: onAlertClose,
              onRetry: onAlertRetry == null
                  ? null
                  : (_) async {
                      await onAlertRetry!(selectedAlert!);
                    },
            ),
          ),
      ],
    );
  }

  void _handleMapCreated(GoogleMapController controller) {
    onMapCreated(controller);
  }
}
