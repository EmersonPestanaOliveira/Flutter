import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class FabPlayground extends StatefulWidget {
  const FabPlayground({super.key});

  @override
  State<FabPlayground> createState() => _FabPlaygroundState();
}

class _FabPlaygroundState extends State<FabPlayground> {
  bool extended = false;
  String label = 'Adicionar';

  @override
  Widget build(BuildContext context) {
    final fab = extended
        ? FloatingActionButton.extended(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: Text(label),
          )
        : FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          );

    return PlaygroundPage(
      title: 'FloatingActionButton',
      preview: fab,
      controls: [
        SwitchListTile(
          title: const Text('VersÃ£o extended'),
          value: extended,
          onChanged: (value) => setState(() => extended = value),
        ),
        if (extended)
          TextControl(
            label: 'Texto',
            initialValue: label,
            onChanged: (value) {
              setState(() => label = value.isEmpty ? 'Adicionar' : value);
            },
          ),
      ],
    );
  }
}
