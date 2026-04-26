import 'package:flutter/material.dart';

import '../widgets/playground_widgets.dart';

class MenuAnchorPlayground extends StatefulWidget {
  const MenuAnchorPlayground({super.key});

  @override
  State<MenuAnchorPlayground> createState() => _MenuAnchorPlaygroundState();
}

class _MenuAnchorPlaygroundState extends State<MenuAnchorPlayground> {
  bool _useFilledButton = true;
  String _lastAction = 'nenhuma';

  @override
  Widget build(BuildContext context) {
    return PlaygroundSection(
      title: 'MenuAnchor',
      description: 'Estrutura moderna de menu ancorado do Material.',
      preview: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MenuAnchor(
            menuChildren: [
              MenuItemButton(
                onPressed: () => setState(() => _lastAction = 'Novo'),
                child: const Text('Novo'),
              ),
              MenuItemButton(
                onPressed: () => setState(() => _lastAction = 'Abrir'),
                child: const Text('Abrir'),
              ),
              MenuItemButton(
                onPressed: () => setState(() => _lastAction = 'Salvar'),
                child: const Text('Salvar'),
              ),
            ],
            builder: (context, controller, child) {
              return _useFilledButton
                  ? FilledButton(
                      onPressed: () {
                        controller.isOpen
                            ? controller.close()
                            : controller.open();
                      },
                      child: const Text('MenuAnchor'),
                    )
                  : OutlinedButton(
                      onPressed: () {
                        controller.isOpen
                            ? controller.close()
                            : controller.open();
                      },
                      child: const Text('MenuAnchor'),
                    );
            },
          ),
          const SizedBox(height: 12),
          Text('Ãšltima aÃ§Ã£o: $_lastAction'),
        ],
      ),
      controls: [
        PlaygroundSwitch(
          title: 'Usar FilledButton',
          value: _useFilledButton,
          onChanged: (value) => setState(() => _useFilledButton = value),
        ),
      ],
    );
  }
}
