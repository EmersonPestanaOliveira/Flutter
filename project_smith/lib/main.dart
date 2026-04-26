import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_smith/screens/home_screen.dart';
import 'package:project_smith/screens/material_catalog_screen.dart';
import 'package:project_smith/screens/splash_screen.dart';
import 'package:project_smith/widgets/text_material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ProjectSmithApp());
}

class ProjectSmithApp extends StatefulWidget {
  const ProjectSmithApp({super.key});

  @override
  State<ProjectSmithApp> createState() => _ProjectSmithAppState();
}

class _ProjectSmithAppState extends State<ProjectSmithApp> {
  ThemeMode _mode = ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Smith',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1976D2)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _mode,
      routes: {
        '/': (_) => SplashScreen(),
        '/home_page': (_) => HomePage(
          onToggleTheme: () => setState(() {
            _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
          }),
          isDark: _mode == ThemeMode.dark,
        ),
        '/material': (_) => MaterialCatalogScreen(),
        '/text': (_) => TextMaterial(),
      },
    );
  }
}
