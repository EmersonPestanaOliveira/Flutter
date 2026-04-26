import 'package:flutter/material.dart';

class DesenvolvimentoDePackagesPage extends StatelessWidget {
  const DesenvolvimentoDePackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desenvolvimento de packages'),
      ),
      body: const Center(
        child: Text(
          'Desenvolvimento de packages',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
