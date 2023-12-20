// main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Olá, Mundo! Flutter'),
        ),
        body: const Center(
          child: Text('Olá, Mundo!'),
        ),
      ),
    ),
  );
}
