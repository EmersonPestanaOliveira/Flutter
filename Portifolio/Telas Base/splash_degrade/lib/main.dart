import 'package:flutter/material.dart';
import 'package:splash_degrade/splash_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Você pode alternar o tema do sistema para ver o degradê mudar.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Evoluída',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const SplashPage(),
    );
  }
}
