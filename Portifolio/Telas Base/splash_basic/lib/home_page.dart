import 'package:flutter/material.dart';

/// HomePage (destino da navegação)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('HomePage', style: TextStyle(fontSize: 24))),
    );
  }
}
