import 'package:flutter/material.dart';
import '../../../widgets/playground/playground_page.dart';

class SwitchPlayground extends StatefulWidget {
  const SwitchPlayground({super.key});

  @override
  State<SwitchPlayground> createState() => _SwitchPlaygroundState();
}

class _SwitchPlaygroundState extends State<SwitchPlayground> {
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Switch',
      preview: Switch(
        value: enabled,
        onChanged: (value) => setState(() => enabled = value),
      ),
      controls: [
        SwitchListTile(
          title: const Text('Ligado'),
          value: enabled,
          onChanged: (value) => setState(() => enabled = value),
        ),
      ],
    );
  }
}
