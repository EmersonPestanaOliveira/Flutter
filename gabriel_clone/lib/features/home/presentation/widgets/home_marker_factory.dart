import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/alerta.dart';
import '../../domain/entities/alerta_cluster.dart';
import '../../domain/entities/camera.dart';
import '../../domain/enums/alerta_tipo.dart';
import 'alert_pin_factory.dart';
import 'pin_cache.dart';

abstract final class HomeMarkerFactory {
  static Marker camera({
    required Camera camera,
    required BitmapDescriptor? icon,
  }) {
    return Marker(
      markerId: MarkerId('camera_${camera.id}'),
      position: LatLng(camera.latitude, camera.longitude),
      icon: icon ?? BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: camera.nome,
        snippet: camera.ativo ? 'Camera ativa' : 'Camera inativa',
      ),
    );
  }

  static Marker alerta({
    required Alerta alerta,
    required Map<AlertaTipo, BitmapDescriptor> icons,
    required ValueChanged<Alerta> onTap,
  }) {
    return Marker(
      markerId: MarkerId('alerta_${alerta.id}'),
      position: LatLng(alerta.latitude, alerta.longitude),
      icon: _alertIcon(alerta, icons),
      anchor: const Offset(0.5, 0.5),
      infoWindow: alerta.isLocalPending
          ? InfoWindow(
              title: _localStatusTitle(alerta.localSyncStatus),
              snippet: alerta.localError == null ? null : 'Toque em Minhas ocorrencias para retry',
            )
          : InfoWindow.noText,
      onTap: () => onTap(alerta),
    );
  }

  static BitmapDescriptor _alertIcon(
    Alerta alerta,
    Map<AlertaTipo, BitmapDescriptor> icons,
  ) {
    return switch (alerta.localSyncStatus) {
      'failed' || 'deadLetter' => BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
      'syncing' => BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueAzure,
        ),
      'queued' => BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueYellow,
        ),
      _ => icons[alerta.tipo] ??
          BitmapDescriptor.defaultMarkerWithHue(AlertPinFactory.hue(alerta.tipo)),
    };
  }

  static String _localStatusTitle(String? status) {
    return switch (status) {
      'syncing' => 'Relato sincronizando',
      'failed' => 'Relato com falha',
      'deadLetter' => 'Relato aguardando retry',
      _ => 'Relato pendente',
    };
  }

  static Future<Marker> alertaCluster({
    required AlertaCluster cluster,
    required Map<AlertaTipo, BitmapDescriptor> icons,
    required ValueChanged<Alerta> onPinTap,
    required ValueChanged<AlertaCluster> onClusterTap,
  }) async {
    final alerta = cluster.singleAlerta;
    if (alerta != null) {
      return HomeMarkerFactory.alerta(
        alerta: alerta,
        icons: icons,
        onTap: onPinTap,
      );
    }

    return Marker(
      markerId: MarkerId(cluster.id),
      position: LatLng(cluster.centerLatitude, cluster.centerLongitude),
      icon: await PinCache.clusterPin(cluster.count),
      anchor: const Offset(0.5, 0.5),
      infoWindow: InfoWindow(title: '${cluster.count} alertas'),
      onTap: () => onClusterTap(cluster),
    );
  }
}
