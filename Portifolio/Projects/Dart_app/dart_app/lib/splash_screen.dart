import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Para usar o logo do Dart em SVG

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      // Navega para a HomeScreen após 3 segundos
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey, // Cor de fundo escura
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Adicione o logo do Dart aqui
            // Você pode baixar o logo do Dart em formato SVG e adicioná-lo à pasta 'assets'
            // Não se esqueça de declarar a pasta 'assets' no seu arquivo pubspec.yaml
            SvgPicture.asset(
              'assets/dart_logo.svg', // Certifique-se que este caminho está correto
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'Aprendendo Dart',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan.shade300),
            ),
          ],
        ),
      ),
    );
  }
}
