import 'package:flutter/material.dart';

import 'buttons/buttons_page.dart';

class MaterialPagePage extends StatelessWidget {
  const MaterialPagePage({super.key});

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
        title: const Text('Material'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('BotÃµes'),
            subtitle: const Text('Exemplos dos principais botÃµes do Material'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () => _open(context, const ButtonsPage()),
          ),
        ],
      ),
    );
  }
}
