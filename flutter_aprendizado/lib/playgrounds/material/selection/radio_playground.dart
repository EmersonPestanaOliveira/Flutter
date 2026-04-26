import 'package:flutter/material.dart';
import '../../../widgets/playground/playground_page.dart';

class RadioPlayground extends StatefulWidget {
  const RadioPlayground({super.key});

  @override
  State<RadioPlayground> createState() => _RadioPlaygroundState();
}

class _RadioPlaygroundState extends State<RadioPlayground> {
  String selected = 'A';

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Radio',
      preview: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<String>(
            title: const Text('OpÃ§Ã£o A'),
            value: 'A',
            groupValue: selected,
            onChanged: (value) => setState(() => selected = value!),
          ),
          RadioListTile<String>(
            title: const Text('OpÃ§Ã£o B'),
            value: 'B',
            groupValue: selected,
            onChanged: (value) => setState(() => selected = value!),
          ),
        ],
      ),
      controls: [
        ListTile(
          title: Text('Selecionado: $selected'),
        ),
      ],
    );
  }
}
