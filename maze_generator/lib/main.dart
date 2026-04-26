import 'package:flutter/material.dart';
import 'package:maze_generator/maze_home.dart';

void main() => runApp(const MazeApp());

class MazeApp extends StatelessWidget {
  const MazeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(primary: Colors.red),
      ),
      home: const MazeHome(),
    );
  }
}
