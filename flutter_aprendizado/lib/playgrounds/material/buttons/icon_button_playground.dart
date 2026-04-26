import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class IconButtonPlayground extends StatefulWidget {
  const IconButtonPlayground({super.key});

  @override
  State<IconButtonPlayground> createState() => _IconButtonPlaygroundState();
}

class _IconButtonPlaygroundState extends State<IconButtonPlayground> {
  double iconSize = 28;
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'IconButton',
      preview: IconButton.filled(
        isSelected: selected,
        iconSize: iconSize,
        onPressed: () {},
        icon: const Icon(Icons.favorite_border),
        selectedIcon: const Icon(Icons.favorite),
      ),
      controls: [
        SliderControl(
          label: 'Icon size',
          value: iconSize,
          min: 16,
          max: 48,
          onChanged: (value) => setState(() => iconSize = value),
        ),
        SwitchListTile(
          title: const Text('Selecionado'),
          value: selected,
          onChanged: (value) => setState(() => selected = value),
        ),
      ],
    );
  }
}
