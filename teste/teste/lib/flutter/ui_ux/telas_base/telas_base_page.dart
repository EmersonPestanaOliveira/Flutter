import 'package:flutter/material.dart';

class TelasBasePagePage extends StatelessWidget {
  const TelasBasePagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Telas Base'),
      ),
      body: const Center(
        child: Text(
          'Telas Base',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
