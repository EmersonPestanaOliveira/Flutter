import 'package:flutter/material.dart';

class TestesPage extends StatelessWidget {
  const TestesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testes'),
      ),
      body: const Center(
        child: Text(
          'Testes',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
