import 'package:flutter/material.dart';

class BatteryStatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const BatteryStatusChip({
    super.key,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, color: color),
      label: Text(label),
      color: WidgetStatePropertyAll(color.withAlpha(26)), // ~10%
      side: BorderSide(color: color.withAlpha(128)), // ~50%
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
    );
  }
}
