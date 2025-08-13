import 'dart:io';

import 'package:dart_app/dart_pad_view_screen.dart';
import 'package:dart_app/home_screen.dart';
import 'package:dart_app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // --- Inicialização da plataforma da WebView (para versões 4.x.x+) ---
  // Esta é a forma mais recomendada para garantir que a implementação de plataforma correta seja registrada.
  // Utiliza 'dart:io' para verificar a plataforma sem depender de BuildContext.
  if (Platform.isAndroid) {
    AndroidWebViewPlatform.registerWith();
  } else if (Platform.isIOS) {
    WebKitWebViewPlatform.registerWith();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart Study App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark, // Tema escuro como nas imagens
        scaffoldBackgroundColor:
            const Color(0xFF0D1117), // Cor de fundo similar
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF161B22), // Cor da AppBar similar
        ),

        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, // Remove o banner de debug
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/dartpad': (context) => const DartPadViewScreen(),
        // Você pode adicionar rotas para cada categoria aqui no futuro
      },
    );
  }
}
