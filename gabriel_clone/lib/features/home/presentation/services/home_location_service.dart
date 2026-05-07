import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<void> goToCurrentLocation({
  required BuildContext context,
  required GoogleMapController? controller,
}) async {
  final messenger = ScaffoldMessenger.of(context);

  if (controller == null) {
    messenger.showSnackBar(
      const SnackBar(content: Text('Mapa ainda não está pronto.')),
    );
    return;
  }

  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    messenger.showSnackBar(
      const SnackBar(content: Text('Ative a localização do dispositivo.')),
    );
    return;
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    messenger.showSnackBar(
      const SnackBar(content: Text('Permissão de localização negada.')),
    );
    return;
  }

  final position = await Geolocator.getCurrentPosition();
  await controller.animateCamera(
    CameraUpdate.newLatLngZoom(
      LatLng(position.latitude, position.longitude),
      15,
    ),
  );
}
