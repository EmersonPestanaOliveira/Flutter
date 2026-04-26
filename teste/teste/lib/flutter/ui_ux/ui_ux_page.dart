import 'package:flutter/material.dart';

import 'componentes/componentes_page.dart';

class UiUxPage extends StatelessWidget {
  const UiUxPage({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI/UX'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Componentes'),
            subtitle: const Text('Widgets e categorias de interface'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () => _open(context, const ComponentesPagePage()),
          ),
        ],
      ),
    );
  }
}
