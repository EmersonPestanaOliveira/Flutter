import 'package:flutter/material.dart';

class GraficosPagePage extends StatelessWidget {
  const GraficosPagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graficos'),
      ),
      body: const Center(
        child: Text(
          'Graficos',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
