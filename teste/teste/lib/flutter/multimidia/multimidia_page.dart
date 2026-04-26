import 'package:flutter/material.dart';

class MultimidiaPage extends StatelessWidget {
  const MultimidiaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multimidia'),
      ),
      body: const Center(
        child: Text(
          'Multimidia',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
