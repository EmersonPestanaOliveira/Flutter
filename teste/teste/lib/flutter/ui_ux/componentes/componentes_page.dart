import 'package:flutter/material.dart';

import 'material/material_page.dart';

class ComponentesPagePage extends StatelessWidget {
  const ComponentesPagePage({super.key});

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
        title: const Text('Componentes'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Material'),
            subtitle: const Text('Componentes do Material Design'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () => _open(context, const MaterialPagePage()),
          ),
        ],
      ),
    );
  }
}
