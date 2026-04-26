import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/alerta.dart';
import '../../domain/entities/camera.dart';
import '../../domain/enums/alerta_tipo.dart';

class HomeMap extends StatelessWidget {
  const HomeMap({
    required this.cameras,
    required this.alertas,
    required this.tabIndex,
    this.onMapCreated,
    super.key,
  });

  static const saoPaulo = LatLng(-23.5505, -46.6333);

  final List<Camera> cameras;
  final List<Alerta> alertas;
  final int tabIndex;
  final void Function(GoogleMapController controller)? onMapCreated;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(target: saoPaulo, zoom: 12),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      onMapCreated: onMapCreated,
      markers: tabIndex == 0 ? _cameraMarkers() : _alertaMarkers(),
    );
  }

  Set<Marker> _cameraMarkers() {
    return cameras
        .map(
          (camera) => Marker(
            markerId: MarkerId('camera_${camera.id}'),
            position: LatLng(camera.latitude, camera.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              camera.ativo
                  ? BitmapDescriptor.hueAzure
                  : BitmapDescriptor.hueRed,
            ),
            infoWindow: InfoWindow(
              title: camera.nome,
              snippet: camera.ativo ? 'Camera ativa' : 'Camera inativa',
            ),
          ),
        )
        .toSet();
  }

  Set<Marker> _alertaMarkers() {
    return alertas
        .where((alerta) => alerta.latitude != 0 && alerta.longitude != 0)
        .map(
          (alerta) => Marker(
            markerId: MarkerId('alerta_${alerta.id}'),
            position: LatLng(alerta.latitude, alerta.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(_alertHue(alerta.tipo)),
            infoWindow: InfoWindow(
              title: alerta.bairro,
              snippet: _alertLabel(alerta.tipo),
            ),
          ),
        )
        .toSet();
  }

  double _alertHue(AlertaTipo tipo) {
    return switch (tipo) {
      AlertaTipo.violencia => BitmapDescriptor.hueRed,
      AlertaTipo.rouboFurto || AlertaTipo.rouboFurtoVeiculo =>
        BitmapDescriptor.hueOrange,
      AlertaTipo.acidente => BitmapDescriptor.hueYellow,
      AlertaTipo.estelionato => BitmapDescriptor.hueCyan,
      AlertaTipo.vandalismo => BitmapDescriptor.hueViolet,
      AlertaTipo.invasao => BitmapDescriptor.hueMagenta,
      AlertaTipo.outros => BitmapDescriptor.hueBlue,
    };
  }

  String _alertLabel(AlertaTipo tipo) {
    return switch (tipo) {
      AlertaTipo.violencia => 'Violencia',
      AlertaTipo.acidente => 'Acidente',
      AlertaTipo.rouboFurtoVeiculo => 'Roubo ou Furto de Veiculos',
      AlertaTipo.rouboFurto => 'Roubo ou Furto',
      AlertaTipo.estelionato => 'Estelionato',
      AlertaTipo.vandalismo => 'Vandalismo',
      AlertaTipo.invasao => 'Invasao',
      AlertaTipo.outros => 'Outros',
    };
  }
}