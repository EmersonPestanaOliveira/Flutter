import 'package:flutter/material.dart';

class RegionalizarPagePage extends StatelessWidget {
  const RegionalizarPagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regionalizar'),
      ),
      body: const Center(
        child: Text(
          'Regionalizar',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
