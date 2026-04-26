import 'package:flutter/material.dart';

class LayoutPagePage extends StatelessWidget {
  const LayoutPagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layout'),
      ),
      body: const Center(
        child: Text(
          'Layout',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
