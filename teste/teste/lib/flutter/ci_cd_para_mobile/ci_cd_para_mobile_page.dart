import 'package:flutter/material.dart';

class CiCdParaMobilePage extends StatelessWidget {
  const CiCdParaMobilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CI/CD para mobile'),
      ),
      body: const Center(
        child: Text(
          'CI/CD para mobile',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
