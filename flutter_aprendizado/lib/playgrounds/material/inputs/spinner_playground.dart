import 'package:flutter/material.dart';
import '../../../widgets/playground/playground_page.dart';

class SpinnerPlayground extends StatefulWidget {
  const SpinnerPlayground({super.key});

  @override
  State<SpinnerPlayground> createState() => _SpinnerPlaygroundState();
}

class _SpinnerPlaygroundState extends State<SpinnerPlayground> {
  final items = ['Masculino', 'Feminino', 'Outro'];
  String? selected = 'Masculino';
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Spinner',
      preview: SizedBox(
        width: 280,
        child: DropdownButtonFormField<String>(
          value: selected,
          decoration: const InputDecoration(
            labelText: 'Selecione',
            border: OutlineInputBorder(),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: enabled
              ? (value) => setState(() => selected = value)
              : null,
        ),
      ),
      controls: [
        SwitchListTile(
          title: const Text('Habilitado'),
          value: enabled,
          onChanged: (value) => setState(() => enabled = value),
        ),
      ],
    );
  }
}
