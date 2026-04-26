import 'package:flutter/material.dart';

class IaPage extends StatelessWidget {
  const IaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IA'),
      ),
      body: const Center(
        child: Text(
          'IA',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
