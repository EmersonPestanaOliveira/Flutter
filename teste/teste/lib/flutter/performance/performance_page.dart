import 'package:flutter/material.dart';

class PerformancePage extends StatelessWidget {
  const PerformancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance'),
      ),
      body: const Center(
        child: Text(
          'Performance',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
