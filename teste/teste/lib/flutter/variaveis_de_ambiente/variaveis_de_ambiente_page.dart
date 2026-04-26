import 'package:flutter/material.dart';

class VariaveisDeAmbientePage extends StatelessWidget {
  const VariaveisDeAmbientePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Variaveis de Ambiente'),
      ),
      body: const Center(
        child: Text(
          'Variaveis de Ambiente',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
