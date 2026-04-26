import 'package:flutter/material.dart';

import '../widgets/playground_widgets.dart';

class TextButtonPlayground extends StatefulWidget {
  const TextButtonPlayground({super.key});

  @override
  State<TextButtonPlayground> createState() => _TextButtonPlaygroundState();
}

class _TextButtonPlaygroundState extends State<TextButtonPlayground> {
  bool _enabled = true;
  bool _withIcon = true;
  String _label = 'TextButton';
  double _padding = 16;
  double _radius = 12;

  @override
  Widget build(BuildContext context) {
    final style = TextButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: _padding, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
      ),
    );

    final button = _withIcon
        ? TextButton.icon(
            onPressed: _enabled ? () {} : null,
            icon: const Icon(Icons.info_outline),
            label: Text(_label),
            style: style,
          )
        : TextButton(
            onPressed: _enabled ? () {} : null,
            style: style,
            child: Text(_label),
          );

    return PlaygroundSection(
      title: 'TextButton',
      description: 'Componente leve, com opÃ§Ã£o de Ã­cone e controle de padding.',
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
      ],
    );
  }
}
