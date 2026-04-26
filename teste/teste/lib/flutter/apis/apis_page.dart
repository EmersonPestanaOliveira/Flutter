import 'package:flutter/material.dart';

class ApisPage extends StatelessWidget {
  const ApisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('APIs'),
      ),
      body: const Center(
        child: Text(
          'APIs',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
