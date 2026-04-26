import 'package:flutter/material.dart';

class ArquiteturasPage extends StatelessWidget {
  const ArquiteturasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arquiteturas'),
      ),
      body: const Center(
        child: Text(
          'Arquiteturas',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
