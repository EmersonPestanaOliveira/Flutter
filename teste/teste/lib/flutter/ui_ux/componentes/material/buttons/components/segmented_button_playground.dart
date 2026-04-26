import 'package:flutter/material.dart';

import '../widgets/playground_widgets.dart';

enum ViewMode { lista, grade, compacto }

class SegmentedButtonPlayground extends StatefulWidget {
  const SegmentedButtonPlayground({super.key});

  @override
  State<SegmentedButtonPlayground> createState() =>
      _SegmentedButtonPlaygroundState();
}

class _SegmentedButtonPlaygroundState
    extends State<SegmentedButtonPlayground> {
  Set<ViewMode> _selected = {ViewMode.lista};
  bool _multi = false;
  bool _emptyAllowed = false;
  bool _showSelectedIcon = true;

  @override
  Widget build(BuildContext context) {
    return PlaygroundSection(
      title: 'SegmentedButton',
      description: 'Permite testar seleÃ§Ã£o simples ou mÃºltipla.',
      preview: Center(
        child: SegmentedButton<ViewMode>(
          multiSelectionEnabled: _multi,
          emptySelectionAllowed: _emptyAllowed,
          showSelectedIcon: _showSelectedIcon,
          segments: const [
            ButtonSegment<ViewMode>(
              value: ViewMode.lista,
              icon: Icon(Icons.view_list),
              label: Text('Lista'),
            ),
            ButtonSegment<ViewMode>(
              value: ViewMode.grade,
              icon: Icon(Icons.grid_view),
              label: Text('Grade'),
            ),
            ButtonSegment<ViewMode>(
              value: ViewMode.compacto,
              icon: Icon(Icons.density_small),
              label: Text('Compacto'),
            ),
          ],
          selected: _selected,
          onSelectionChanged: (values) {
            setState(() {
              _selected = values;
            });
          },
        ),
      ),
      controls: [
        PlaygroundSwitch(
          title: 'MÃºltipla seleÃ§Ã£o',
          value: _multi,
          onChanged: (value) {
            setState(() {
              _multi = value;
              if (!_multi && _selected.length > 1) {
                _selected = {_selected.first};
              }
            });
          },
        ),
        PlaygroundSwitch(
          title: 'Permitir vazio',
          value: _emptyAllowed,
          onChanged: (value) => setState(() => _emptyAllowed = value),
        ),
        PlaygroundSwitch(
          title: 'Mostrar Ã­cone do selecionado',
          value: _showSelectedIcon,
          onChanged: (value) => setState(() => _showSelectedIcon = value),
        ),
      ],
    );
  }
}
