import 'package:flutter/material.dart';

class DesignPatternsPage extends StatelessWidget {
  const DesignPatternsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design Patterns'),
      ),
      body: const Center(
        child: Text(
          'Design Patterns',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
