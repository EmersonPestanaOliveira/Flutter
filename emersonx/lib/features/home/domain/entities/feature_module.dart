import 'package:flutter/material.dart';

class FeatureModule {
  const FeatureModule({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.icon,
    required this.color,
    this.isReady = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final String route;
  final IconData icon;
  final Color color;
  final bool isReady;
}