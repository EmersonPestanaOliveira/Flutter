import 'package:flutter/material.dart';

import '../widgets/playground_widgets.dart';

class ElevatedButtonPlayground extends StatefulWidget {
  const ElevatedButtonPlayground({super.key});

  @override
  State<ElevatedButtonPlayground> createState() =>
      _ElevatedButtonPlaygroundState();
}

class _ElevatedButtonPlaygroundState extends State<ElevatedButtonPlayground> {
  bool _enabled = true;
  bool _withIcon = true;
  String _label = 'ElevatedButton';
  double _padding = 16;
  double _elevation = 1;
  double _radius = 12;

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: _padding, vertical: 16),
      elevation: _elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
      ),
    );

    final button = _withIcon
        ? ElevatedButton.icon(
            onPressed: _enabled ? () {} : null,
            icon: const Icon(Icons.send),
            label: Text(_label),
            style: style,
          )
        : ElevatedButton(
            onPressed: _enabled ? () {} : null,
            style: style,
            child: Text(_label),
          );

    return PlaygroundSection(
      title: 'ElevatedButton',
      description: 'Preview separado para editar os principais parÃ¢metros.',
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
        PlaygroundSwitch(
          title: 'Mostrar Ã­cone',
          value: _withIcon,
          onChanged: (value) => setState(() => _withIcon = value),
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
          label: 'Elevation',
          value: _elevation,
          min: 0,
          max: 12,
          divisions: 12,
          onChanged: (value) => setState(() => _elevation = value),
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
