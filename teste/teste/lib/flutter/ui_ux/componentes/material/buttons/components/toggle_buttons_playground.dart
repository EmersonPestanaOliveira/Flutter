import 'package:flutter/material.dart';

import '../widgets/playground_widgets.dart';

class ToggleButtonsPlayground extends StatefulWidget {
  const ToggleButtonsPlayground({super.key});

  @override
  State<ToggleButtonsPlayground> createState() =>
      _ToggleButtonsPlaygroundState();
}

class _ToggleButtonsPlaygroundState extends State<ToggleButtonsPlayground> {
  List<bool> _selected = [true, false, false];
  bool _vertical = false;
  bool _border = true;
  double _borderRadius = 8;

  @override
  Widget build(BuildContext context) {
    return PlaygroundSection(
      title: 'ToggleButtons',
      description: 'Controle simples de direÃ§Ã£o, borda e seleÃ§Ã£o.',
      preview: Center(
        child: ToggleButtons(
          isSelected: _selected,
          direction: _vertical ? Axis.vertical : Axis.horizontal,
          borderRadius: BorderRadius.circular(_borderRadius),
          renderBorder: _border,
          onPressed: (index) {
            setState(() {
              for (var i = 0; i < _selected.length; i++) {
                _selected[i] = i == index;
              }
            });
          },
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.format_align_left),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.format_align_center),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.format_align_right),
            ),
          ],
        ),
      ),
      controls: [
        PlaygroundSwitch(
          title: 'Vertical',
          value: _vertical,
          onChanged: (value) => setState(() => _vertical = value),
        ),
        PlaygroundSwitch(
          title: 'Renderizar borda',
          value: _border,
          onChanged: (value) => setState(() => _border = value),
        ),
        PlaygroundSlider(
          label: 'Raio da borda',
          value: _borderRadius,
          min: 0,
          max: 24,
          divisions: 12,
          onChanged: (value) => setState(() => _borderRadius = value),
        ),
      ],
    );
  }
}
