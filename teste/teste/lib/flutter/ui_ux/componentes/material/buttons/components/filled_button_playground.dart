import 'package:flutter/material.dart';

import '../widgets/playground_widgets.dart';

enum FilledVariant {
  filled,
  filledIcon,
  tonal,
  tonalIcon,
}

class FilledButtonPlayground extends StatefulWidget {
  const FilledButtonPlayground({super.key});

  @override
  State<FilledButtonPlayground> createState() => _FilledButtonPlaygroundState();
}

class _FilledButtonPlaygroundState extends State<FilledButtonPlayground> {
  bool _enabled = true;
  String _label = 'FilledButton';
  double _padding = 16;
  double _radius = 16;
  FilledVariant _variant = FilledVariant.filled;

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: _padding, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
      ),
    );

    late final Widget button;

    switch (_variant) {
      case FilledVariant.filled:
        button = FilledButton(
          onPressed: _enabled ? () {} : null,
          style: style,
          child: Text(_label),
        );
        break;
      case FilledVariant.filledIcon:
        button = FilledButton.icon(
          onPressed: _enabled ? () {} : null,
          style: style,
          icon: const Icon(Icons.check),
          label: Text(_label),
        );
        break;
      case FilledVariant.tonal:
        button = FilledButton.tonal(
          onPressed: _enabled ? () {} : null,
          style: style,
          child: Text(_label),
        );
        break;
      case FilledVariant.tonalIcon:
        button = FilledButton.tonalIcon(
          onPressed: _enabled ? () {} : null,
          style: style,
          icon: const Icon(Icons.palette),
          label: Text(_label),
        );
        break;
    }

    return PlaygroundSection(
      title: 'FilledButton',
      description: 'Inclui FilledButton, FilledButton.icon, tonal e tonalIcon.',
      preview: Center(child: button),
      controls: [
        PlaygroundTextField(
          label: 'Texto',
          initialValue: _label,
          onChanged: (value) => setState(() => _label = value),
        ),
        PlaygroundSwitch(
          title: 'Habilitado',
          value: _enabled,
          onChanged: (value) => setState(() => _enabled = value),
        ),
        PlaygroundDropdown<FilledVariant>(
          label: 'VariaÃ§Ã£o',
          value: _variant,
          items: const [
            DropdownMenuItem(
              value: FilledVariant.filled,
              child: Text('FilledButton'),
            ),
            DropdownMenuItem(
              value: FilledVariant.filledIcon,
              child: Text('FilledButton.icon'),
            ),
            DropdownMenuItem(
              value: FilledVariant.tonal,
              child: Text('FilledButton.tonal'),
            ),
            DropdownMenuItem(
              value: FilledVariant.tonalIcon,
              child: Text('FilledButton.tonalIcon'),
            ),
          ],
          onChanged: (value) => setState(() => _variant = value!),
        ),
        PlaygroundSlider(
          label: 'Padding horizontal',
          value: _padding,
          min: 8,
          max: 40,
          divisions: 16,
          onChanged: (value) => setState(() => _padding = value),
        ),
        PlaygroundSlider(
          label: 'Raio da borda',
          value: _radius,
          min: 0,
          max: 32,
          divisions: 16,
          onChanged: (value) => setState(() => _radius = value),
        ),
      ],
    );
  }
}
