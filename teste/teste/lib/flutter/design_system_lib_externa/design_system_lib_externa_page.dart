import 'package:flutter/material.dart';

class DesignSystemLibExternaPage extends StatelessWidget {
  const DesignSystemLibExternaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design system lib externa'),
      ),
      body: const Center(
        child: Text(
          'Design system lib externa',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
