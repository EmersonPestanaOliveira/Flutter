import 'package:flutter/material.dart';

class ConectividadePage extends StatelessWidget {
  const ConectividadePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conectividade'),
      ),
      body: const Center(
        child: Text(
          'Conectividade',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
