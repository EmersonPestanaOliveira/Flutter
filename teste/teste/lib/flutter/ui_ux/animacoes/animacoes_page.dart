import 'package:flutter/material.dart';

class AnimacoesPagePage extends StatelessWidget {
  const AnimacoesPagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animacoes'),
      ),
      body: const Center(
        child: Text(
          'Animacoes',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
