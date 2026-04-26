import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class FilledButtonPlayground extends StatefulWidget {
  const FilledButtonPlayground({super.key});

  @override
  State<FilledButtonPlayground> createState() => _FilledButtonPlaygroundState();
}

class _FilledButtonPlaygroundState extends State<FilledButtonPlayground> {
  String label = 'FilledButton';
  bool enabled = true;
  double fontSize = 16;
  double borderRadius = 12;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'FilledButton',
      preview: FilledButton(
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
            setState(() => label = value.isEmpty ? 'FilledButton' : value);
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
