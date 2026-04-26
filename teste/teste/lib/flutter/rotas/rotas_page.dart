import 'package:flutter/material.dart';

class RotasPage extends StatelessWidget {
  const RotasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rotas'),
      ),
      body: const Center(
        child: Text(
          'Rotas',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
