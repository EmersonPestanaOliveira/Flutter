import 'package:flutter/material.dart';
import 'package:teste/flutter/acessibilidade/acessibilidade_page.dart';

import 'ui_ux/ui_ux_page.dart';

class FlutterPage extends StatelessWidget {
  const FlutterPage({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('UI/UX'),
            subtitle: const Text('Explorar organizaÃ§Ã£o visual e componentes'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () => _open(context, const UiUxPage()),
          ),
          ListTile(
            title: const Text("Acessibilidade"),
            subtitle: const Text(
              "Semantics, contraste, foco, escala de texto e boas práticas",
            ),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AcessibilidadePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
