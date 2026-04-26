import 'package:flutter/material.dart';

class AlgoritmosPage extends StatelessWidget {
  const AlgoritmosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Algoritmos'),
      ),
      body: const Center(
        child: Text(
          'Algoritmos',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
