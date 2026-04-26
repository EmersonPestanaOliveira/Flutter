import 'package:flutter/material.dart';

class VscodePage extends StatelessWidget {
  const VscodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VScode'),
      ),
      body: const Center(
        child: Text(
          'VScode',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
