import 'package:flutter/material.dart';

class TemasPagePage extends StatelessWidget {
  const TemasPagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temas'),
      ),
      body: const Center(
        child: Text(
          'Temas',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
