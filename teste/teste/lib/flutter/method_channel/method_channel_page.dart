import 'package:flutter/material.dart';

class MethodChannelPage extends StatelessWidget {
  const MethodChannelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Method Channel'),
      ),
      body: const Center(
        child: Text(
          'Method Channel',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
