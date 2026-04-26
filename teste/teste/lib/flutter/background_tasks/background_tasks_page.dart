import 'package:flutter/material.dart';

class BackgroundTasksPage extends StatelessWidget {
  const BackgroundTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Background tasks'),
      ),
      body: const Center(
        child: Text(
          'Background tasks',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
