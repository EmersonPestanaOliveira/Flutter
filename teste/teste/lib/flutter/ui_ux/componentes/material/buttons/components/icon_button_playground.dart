import 'package:flutter/material.dart';

import '../widgets/playground_widgets.dart';

enum IconButtonVariant {
  standard,
  filled,
  filledTonal,
  outlined,
}

class IconButtonPlayground extends StatefulWidget {
  const IconButtonPlayground({super.key});

  @override
  State<IconButtonPlayground> createState() => _IconButtonPlaygroundState();
}

class _IconButtonPlaygroundState extends State<IconButtonPlayground> {
  bool _enabled = true;
  bool _selected = false;
  double _iconSize = 24;
  String _tooltip = 'AÃ§Ã£o';
  IconButtonVariant _variant = IconButtonVariant.standard;

  @override
  Widget build(BuildContext context) {
    Widget button;

    switch (_variant) {
      case IconButtonVariant.standard:
        button = IconButton(
          onPressed: _enabled ? () => setState(() => _selected = !_selected) : null,
          isSelected: _selected,
          tooltip: _tooltip,
          iconSize: _iconSize,
          icon: const Icon(Icons.favorite_border),
          selectedIcon: const Icon(Icons.favorite),
        );
        break;
      case IconButtonVariant.filled:
        button = IconButton.filled(
          onPressed: _enabled ? () => setState(() => _selected = !_selected) : null,
          isSelected: _selected,
          tooltip: _tooltip,
          iconSize: _iconSize,
          icon: const Icon(Icons.bookmark_border),
          selectedIcon: const Icon(Icons.bookmark),
        );
        break;
      case IconButtonVariant.filledTonal:
        button = IconButton.filledTonal(
          onPressed: _enabled ? () => setState(() => _selected = !_selected) : null,
          isSelected: _selected,
          tooltip: _tooltip,
          iconSize: _iconSize,
          icon: const Icon(Icons.star_border),
          selectedIcon: const Icon(Icons.star),
        );
        break;
      case IconButtonVariant.outlined:
        button = IconButton.outlined(
          onPressed: _enabled ? () => setState(() => _selected = !_selected) : null,
          isSelected: _selected,
          tooltip: _tooltip,
          iconSize: _iconSize,
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
        );
        break;
    }

    return PlaygroundSection(
      title: 'IconButton',
      description: 'Com suporte Ã s variantes padrÃ£o, filled, tonal e outlined.',
      preview: Center(child: button),
      controls: [
        PlaygroundTextField(
          label: 'Tooltip',
          initialValue: _tooltip,
          onChanged: (value) => setState(() => _tooltip = value),
        ),
        PlaygroundSwitch(
          title: 'Habilitado',
          value: _enabled,
          onChanged: (value) => setState(() => _enabled = value),
        ),
        PlaygroundSwitch(
          title: 'Selecionado',
          value: _selected,
          onChanged: (value) => setState(() => _selected = value),
        ),
        PlaygroundDropdown<IconButtonVariant>(
          label: 'VariaÃ§Ã£o',
          value: _variant,
          items: const [
            DropdownMenuItem(
              value: IconButtonVariant.standard,
              child: Text('IconButton'),
            ),
            DropdownMenuItem(
              value: IconButtonVariant.filled,
              child: Text('IconButton.filled'),
            ),
            DropdownMenuItem(
              value: IconButtonVariant.filledTonal,
              child: Text('IconButton.filledTonal'),
            ),
            DropdownMenuItem(
              value: IconButtonVariant.outlined,
              child: Text('IconButton.outlined'),
            ),
          ],
          onChanged: (value) => setState(() => _variant = value!),
        ),
        PlaygroundSlider(
          label: 'Tamanho do Ã­cone',
          value: _iconSize,
          min: 16,
          max: 48,
          divisions: 16,
          onChanged: (value) => setState(() => _iconSize = value),
        ),
      ],
    );
  }
}
