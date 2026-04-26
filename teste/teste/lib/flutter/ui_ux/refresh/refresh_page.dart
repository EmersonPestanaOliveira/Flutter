import 'package:flutter/material.dart';

class RefreshPagePage extends StatelessWidget {
  const RefreshPagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refresh'),
      ),
      body: const Center(
        child: Text(
          'Refresh',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
