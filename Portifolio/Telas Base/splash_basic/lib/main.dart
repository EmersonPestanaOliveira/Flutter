import 'package:flutter/material.dart';
import 'package:splash_basic/splash_page.dart';

void main() {
  runApp(const MyApp());
}

/// App raiz
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Splash Demo',
      home: const SplashPage(),
    );
  }
}
