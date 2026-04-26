import 'package:flutter/material.dart';

import '../widgets/playground_widgets.dart';

enum FabVariant {
  small,
  regular,
  large,
  extended,
}

class FloatingActionButtonPlayground extends StatefulWidget {
  const FloatingActionButtonPlayground({super.key});

  @override
  State<FloatingActionButtonPlayground> createState() =>
      _FloatingActionButtonPlaygroundState();
}

class _FloatingActionButtonPlaygroundState
    extends State<FloatingActionButtonPlayground> {
  bool _enabled = true;
  String _label = 'Salvar';
  String _tooltip = 'AÃ§Ã£o principal';
  double _elevation = 6;
  FabVariant _variant = FabVariant.regular;

  @override
  Widget build(BuildContext context) {
    Widget button;

    switch (_variant) {
      case FabVariant.small:
        button = FloatingActionButton.small(
          onPressed: _enabled ? () {} : null,
          tooltip: _tooltip,
          elevation: _elevation,
          child: const Icon(Icons.add),
        );
        break;
      case FabVariant.regular:
        button = FloatingActionButton(
          onPressed: _enabled ? () {} : null,
          tooltip: _tooltip,
          elevation: _elevation,
          child: const Icon(Icons.edit),
        );
        break;
      case FabVariant.large:
        button = FloatingActionButton.large(
          onPressed: _enabled ? () {} : null,
          tooltip: _tooltip,
          elevation: _elevation,
          child: const Icon(Icons.navigation),
        );
        break;
      case FabVariant.extended:
        button = FloatingActionButton.extended(
          onPressed: _enabled ? () {} : null,
          tooltip: _tooltip,
          elevation: _elevation,
          icon: const Icon(Icons.save),
          label: Text(_label),
        );
        break;
    }

    return PlaygroundSection(
      title: 'FloatingActionButton',
      description: 'Preview para small, regular, large e extended.',
      preview: Center(child: button),
      controls: [
        PlaygroundTextField(
          label: 'Texto (extended)',
          initialValue: _label,
          onChanged: (value) => setState(() => _label = value),
        ),
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
        PlaygroundDropdown<FabVariant>(
          label: 'VariaÃ§Ã£o',
          value: _variant,
          items: const [
            DropdownMenuItem(value: FabVariant.small, child: Text('small')),
            DropdownMenuItem(value: FabVariant.regular, child: Text('regular')),
            DropdownMenuItem(value: FabVariant.large, child: Text('large')),
            DropdownMenuItem(value: FabVariant.extended, child: Text('extended')),
          ],
          onChanged: (value) => setState(() => _variant = value!),
        ),
        PlaygroundSlider(
          label: 'Elevation',
          value: _elevation,
          min: 0,
          max: 16,
          divisions: 16,
          onChanged: (value) => setState(() => _elevation = value),
        ),
      ],
    );
  }
}
