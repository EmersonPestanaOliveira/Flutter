import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract final class AppMapBounds {
  /// Bounds aproximado da regiao Sudeste do Brasil: SP, RJ, MG e ES.
  ///
  /// Usado como limite de navegacao do Google Maps para manter a UX dentro da
  /// area operacional do app sem interferir nas queries de viewport.
  static final southeastBrazil = LatLngBounds(
    southwest: const LatLng(-25.35, -53.20),
    northeast: const LatLng(-13.90, -39.60),
  );

  static final southeastBrazilCameraTarget =
      CameraTargetBounds(southeastBrazil);
}
