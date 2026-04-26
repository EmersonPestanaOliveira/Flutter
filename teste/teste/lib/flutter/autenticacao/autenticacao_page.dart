import 'package:flutter/material.dart';

class AutenticacaoPage extends StatelessWidget {
  const AutenticacaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AutenticaÃ§Ã£o'),
      ),
      body: const Center(
        child: Text(
          'AutenticaÃ§Ã£o',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
