import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DangerZone {
  const DangerZone({
    required this.id,
    required this.eventType,
    required this.color,
    required this.center,
    required this.radiusMeters,
    required this.eventCount,
    required this.updatedAt,
  });

  final String id;
  final String eventType;
  final Color color;
  final LatLng center;
  final double radiusMeters;
  final int eventCount;
  final DateTime updatedAt;
}
