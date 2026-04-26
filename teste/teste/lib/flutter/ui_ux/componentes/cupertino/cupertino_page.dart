import 'package:flutter/material.dart';

class CupertinoPagePage extends StatelessWidget {
  const CupertinoPagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cupertino'),
      ),
      body: const Center(
        child: Text(
          'Cupertino',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
