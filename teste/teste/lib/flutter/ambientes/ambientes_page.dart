import 'package:flutter/material.dart';

class AmbientesPage extends StatelessWidget {
  const AmbientesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambientes'),
      ),
      body: const Center(
        child: Text(
          'Ambientes',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
