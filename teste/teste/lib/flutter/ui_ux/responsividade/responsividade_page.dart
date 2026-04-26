import 'package:flutter/material.dart';

class ResponsividadePagePage extends StatelessWidget {
  const ResponsividadePagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsividade'),
      ),
      body: const Center(
        child: Text(
          'Responsividade',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
