import 'package:flutter/material.dart';

class CompilacaoNativaPage extends StatelessWidget {
  const CompilacaoNativaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CompilaÃ§Ã£o Nativa'),
      ),
      body: const Center(
        child: Text(
          'CompilaÃ§Ã£o Nativa',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
