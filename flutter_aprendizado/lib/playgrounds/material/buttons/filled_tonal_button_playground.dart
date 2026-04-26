import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class FilledTonalButtonPlayground extends StatefulWidget {
  const FilledTonalButtonPlayground({super.key});

  @override
  State<FilledTonalButtonPlayground> createState() =>
      _FilledTonalButtonPlaygroundState();
}

class _FilledTonalButtonPlaygroundState
    extends State<FilledTonalButtonPlayground> {
  String label = 'FilledButton Tonal';
  bool enabled = true;
  double fontSize = 16;
  double borderRadius = 12;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'FilledButton Tonal',
      preview: FilledButton.tonal(
        onPressed: enabled ? () {} : null,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(label, style: TextStyle(fontSize: fontSize)),
      ),
      controls: [
        TextControl(
          label: 'Texto',
          initialValue: label,
          onChanged: (value) {
            setState(() {
              label = value.isEmpty ? 'FilledButton Tonal' : value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('Habilitado'),
          value: enabled,
          onChanged: (value) => setState(() => enabled = value),
        ),
        SliderControl(
          label: 'Font size',
          value: fontSize,
          min: 10,
          max: 32,
          onChanged: (value) => setState(() => fontSize = value),
        ),
        SliderControl(
          label: 'Border radius',
          value: borderRadius,
          min: 0,
          max: 40,
          onChanged: (value) => setState(() => borderRadius = value),
        ),
      ],
    );
  }
}
