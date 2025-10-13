import 'package:flutter/material.dart';

/// =============================================================
/// Widgets utilitários
/// =============================================================
class LabeledSlider extends StatelessWidget {
  const LabeledSlider({
    required this.label,
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final double min, max, value;
  final ValueChanged<double> onChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              value.toStringAsFixed(2),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        Slider(
          min: min,
          max: max,
          value: value.clamp(min, max),
          onChanged: onChanged,
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}
