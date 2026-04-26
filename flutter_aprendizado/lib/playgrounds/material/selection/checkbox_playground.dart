import 'package:flutter/material.dart';
import '../../../widgets/playground/playground_page.dart';

class CheckboxPlayground extends StatefulWidget {
  const CheckboxPlayground({super.key});

  @override
  State<CheckboxPlayground> createState() => _CheckboxPlaygroundState();
}

class _CheckboxPlaygroundState extends State<CheckboxPlayground> {
  bool checked = true;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Checkbox',
      preview: Checkbox(
        value: checked,
        onChanged: (value) => setState(() => checked = value ?? false),
      ),
      controls: [
        SwitchListTile(
          title: const Text('Marcado'),
          value: checked,
          onChanged: (value) => setState(() => checked = value),
        ),
      ],
    );
  }
}
