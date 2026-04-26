import 'package:flutter/material.dart';
import '../../../widgets/playground/playground_page.dart';

class DropdownMenuPlayground extends StatefulWidget {
  const DropdownMenuPlayground({super.key});

  @override
  State<DropdownMenuPlayground> createState() => _DropdownMenuPlaygroundState();
}

class _DropdownMenuPlaygroundState extends State<DropdownMenuPlayground> {
  String? selected;
  bool enabled = true;

  final List<String> items = [
    'Peito',
    'Costas',
    'Perna',
    'Cardio',
  ];

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'DropdownMenu',
      preview: SizedBox(
        width: 260,
        child: DropdownMenu<String>(
          enabled: enabled,
          initialSelection: selected,
          onSelected: (value) => setState(() => selected = value),
          dropdownMenuEntries: items
              .map(
                (item) => DropdownMenuEntry<String>(
                  value: item,
                  label: item,
                ),
              )
              .toList(),
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
