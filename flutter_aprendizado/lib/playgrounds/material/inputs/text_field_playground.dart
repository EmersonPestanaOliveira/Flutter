import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class TextFieldPlayground extends StatefulWidget {
  const TextFieldPlayground({super.key});

  @override
  State<TextFieldPlayground> createState() => _TextFieldPlaygroundState();
}

class _TextFieldPlaygroundState extends State<TextFieldPlayground> {
  String label = 'Seu nome';
  String hint = 'Digite aqui';
  String helper = 'Campo de exemplo';
  bool obscureText = false;
  bool enabled = true;
  bool filled = false;
  double maxLines = 1;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'TextField',
      preview: SizedBox(
        width: 280,
        child: TextField(
          enabled: enabled,
          obscureText: obscureText,
          maxLines: maxLines.round(),
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            helperText: helper,
            filled: filled,
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
        TextControl(
          label: 'Helper',
          initialValue: helper,
          onChanged: (value) => setState(() => helper = value),
        ),
        SwitchListTile(
          title: const Text('Obscure text'),
          value: obscureText,
          onChanged: (value) => setState(() => obscureText = value),
        ),
        SwitchListTile(
          title: const Text('Enabled'),
          value: enabled,
          onChanged: (value) => setState(() => enabled = value),
        ),
        SwitchListTile(
          title: const Text('Filled'),
          value: filled,
          onChanged: (value) => setState(() => filled = value),
        ),
        SliderControl(
          label: 'Max lines',
          value: maxLines,
          min: 1,
          max: 5,
          onChanged: (value) => setState(() => maxLines = value),
        ),
      ],
    );
  }
}
