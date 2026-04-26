import 'package:flutter/material.dart';

class LojasPage extends StatelessWidget {
  const LojasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lojas'),
      ),
      body: const Center(
        child: Text(
          'Lojas',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
