import 'package:flutter/material.dart';

class SensoresPage extends StatelessWidget {
  const SensoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensores'),
      ),
      body: const Center(
        child: Text(
          'Sensores',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
