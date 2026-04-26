import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class TextBoxPlayground extends StatefulWidget {
  const TextBoxPlayground({super.key});

  @override
  State<TextBoxPlayground> createState() => _TextBoxPlaygroundState();
}

class _TextBoxPlaygroundState extends State<TextBoxPlayground> {
  String label = 'DescriÃ§Ã£o';
  String hint = 'Digite um texto maior';
  int maxLines = 4;
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Text Box',
      preview: SizedBox(
        width: 300,
        child: TextField(
          enabled: enabled,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
      controls: [
        TextControl(
          label: 'Label',
          initialValue: label,
          onChanged: (value) => setState(() => label = value),
        ),
        TextControl(
          label: 'Hint',
          initialValue: hint,
          onChanged: (value) => setState(() => hint = value),
        ),
        SwitchListTile(
          title: const Text('Habilitado'),
          value: enabled,
          onChanged: (value) => setState(() => enabled = value),
        ),
        SliderControl(
          label: 'Max lines',
          value: maxLines.toDouble(),
          min: 2,
          max: 10,
          onChanged: (value) => setState(() => maxLines = value.round()),
        ),
      ],
    );
  }
}
