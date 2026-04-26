import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class OutlinedButtonPlayground extends StatefulWidget {
  const OutlinedButtonPlayground({super.key});

  @override
  State<OutlinedButtonPlayground> createState() =>
      _OutlinedButtonPlaygroundState();
}

class _OutlinedButtonPlaygroundState extends State<OutlinedButtonPlayground> {
  String label = 'OutlinedButton';
  bool enabled = true;
  double fontSize = 16;
  double borderRadius = 12;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'OutlinedButton',
      preview: OutlinedButton(
        onPressed: enabled ? () {} : null,
        style: OutlinedButton.styleFrom(
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
            setState(() => label = value.isEmpty ? 'OutlinedButton' : value);
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
