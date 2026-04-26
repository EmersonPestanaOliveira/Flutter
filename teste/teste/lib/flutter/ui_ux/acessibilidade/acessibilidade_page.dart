import 'package:flutter/material.dart';

class AcessibilidadePagePage extends StatelessWidget {
  const AcessibilidadePagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acessibilidade'),
      ),
      body: const Center(
        child: Text(
          'Acessibilidade',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
