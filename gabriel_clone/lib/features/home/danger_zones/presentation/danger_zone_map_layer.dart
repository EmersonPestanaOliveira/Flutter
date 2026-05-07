import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../domain/danger_zone.dart';

abstract final class DangerZoneMapLayer {
  static Set<Circle> circlesFor(List<DangerZone> zones) {
    return zones.map((zone) {
      return Circle(
        circleId: CircleId(zone.id),
        center: zone.center,
        radius: zone.radiusMeters,
        fillColor: zone.color.withValues(alpha: 0.22),
        strokeColor: zone.color,
        strokeWidth: 2,
        consumeTapEvents: false,
      );
    }).toSet();
  }
}
