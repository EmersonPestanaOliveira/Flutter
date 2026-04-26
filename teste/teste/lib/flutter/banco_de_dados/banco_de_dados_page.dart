import 'package:flutter/material.dart';

class BancoDeDadosPage extends StatelessWidget {
  const BancoDeDadosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banco de dados'),
      ),
      body: const Center(
        child: Text(
          'Banco de dados',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
