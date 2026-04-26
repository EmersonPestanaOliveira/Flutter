import 'package:flutter/material.dart';

import '../widgets/playground_widgets.dart';

class OutlinedButtonPlayground extends StatefulWidget {
  const OutlinedButtonPlayground({super.key});

  @override
  State<OutlinedButtonPlayground> createState() =>
      _OutlinedButtonPlaygroundState();
}

class _OutlinedButtonPlaygroundState extends State<OutlinedButtonPlayground> {
  bool _enabled = true;
  bool _withIcon = true;
  String _label = 'OutlinedButton';
  double _padding = 16;
  double _radius = 16;
  double _borderWidth = 1;

  @override
  Widget build(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      side: BorderSide(width: _borderWidth),
      padding: EdgeInsets.symmetric(horizontal: _padding, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
      ),
    );

    final button = _withIcon
        ? OutlinedButton.icon(
            onPressed: _enabled ? () {} : null,
            icon: const Icon(Icons.open_in_new),
            label: Text(_label),
            style: style,
          )
        : OutlinedButton(
            onPressed: _enabled ? () {} : null,
            style: style,
            child: Text(_label),
          );

    return PlaygroundSection(
      title: 'OutlinedButton',
      description: 'Preview isolado com borda, Ã­cone e raio ajustÃ¡veis.',
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
          label: 'Raio da borda',
          value: _radius,
          min: 0,
          max: 32,
          divisions: 16,
          onChanged: (value) => setState(() => _radius = value),
        ),
        PlaygroundSlider(
          label: 'Espessura da borda',
          value: _borderWidth,
          min: 0.5,
          max: 6,
          divisions: 11,
          onChanged: (value) => setState(() => _borderWidth = value),
        ),
      ],
    );
  }
}
