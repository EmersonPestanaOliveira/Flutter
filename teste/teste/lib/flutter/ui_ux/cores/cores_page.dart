import 'package:flutter/material.dart';

class CoresPagePage extends StatelessWidget {
  const CoresPagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cores'),
      ),
      body: const Center(
        child: Text(
          'Cores',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
