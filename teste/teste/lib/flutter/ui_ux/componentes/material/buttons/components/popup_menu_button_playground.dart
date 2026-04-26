import 'package:flutter/material.dart';

import '../widgets/playground_widgets.dart';

class PopupMenuButtonPlayground extends StatefulWidget {
  const PopupMenuButtonPlayground({super.key});

  @override
  State<PopupMenuButtonPlayground> createState() =>
      _PopupMenuButtonPlaygroundState();
}

class _PopupMenuButtonPlaygroundState
    extends State<PopupMenuButtonPlayground> {
  bool _enabled = true;
  bool _useChild = false;
  String _selected = 'nenhum';
  double _offsetY = 8;
  double _iconSize = 24;

  @override
  Widget build(BuildContext context) {
    final button = PopupMenuButton<String>(
      enabled: _enabled,
      tooltip: 'Mais aÃ§Ãµes',
      iconSize: _iconSize,
      offset: Offset(0, _offsetY),
      initialValue: _selected == 'nenhum' ? null : _selected,
      icon: _useChild ? null : const Icon(Icons.more_vert),
      child: _useChild
          ? const Padding(
              padding: EdgeInsets.all(12),
              child: Text('Abrir menu'),
            )
          : null,
      onSelected: (value) {
        setState(() {
          _selected = value;
        });
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'editar',
          child: Text('Editar'),
        ),
        PopupMenuItem(
          value: 'duplicar',
          child: Text('Duplicar'),
        ),
        PopupMenuItem(
          value: 'excluir',
          child: Text('Excluir'),
        ),
      ],
    );

    return PlaygroundSection(
      title: 'PopupMenuButton',
      description: 'Preview do menu pop-up com child ou icon.',
      preview: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          button,
          const SizedBox(height: 12),
          Text('Selecionado: $_selected'),
        ],
      ),
      controls: [
        PlaygroundSwitch(
          title: 'Habilitado',
          value: _enabled,
          onChanged: (value) => setState(() => _enabled = value),
        ),
        PlaygroundSwitch(
          title: 'Usar child em vez de icon',
          value: _useChild,
          onChanged: (value) => setState(() => _useChild = value),
        ),
        PlaygroundSlider(
          label: 'Offset Y',
          value: _offsetY,
          min: 0,
          max: 24,
          divisions: 12,
          onChanged: (value) => setState(() => _offsetY = value),
        ),
        PlaygroundSlider(
          label: 'Tamanho do Ã­cone',
          value: _iconSize,
          min: 16,
          max: 40,
          divisions: 12,
          onChanged: (value) => setState(() => _iconSize = value),
        ),
      ],
    );
  }
}
