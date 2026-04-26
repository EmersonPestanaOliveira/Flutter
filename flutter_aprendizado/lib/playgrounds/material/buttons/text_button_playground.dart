import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class TextButtonPlayground extends StatefulWidget {
  const TextButtonPlayground({super.key});

  @override
  State<TextButtonPlayground> createState() => _TextButtonPlaygroundState();
}

class _TextButtonPlaygroundState extends State<TextButtonPlayground> {
  String label = 'TextButton';
  bool enabled = true;
  double fontSize = 16;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'TextButton',
      preview: TextButton(
        onPressed: enabled ? () {} : null,
        child: Text(label, style: TextStyle(fontSize: fontSize)),
      ),
      controls: [
        TextControl(
          label: 'Texto',
          initialValue: label,
          onChanged: (value) {
            setState(() => label = value.isEmpty ? 'TextButton' : value);
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
      ],
    );
  }
}
