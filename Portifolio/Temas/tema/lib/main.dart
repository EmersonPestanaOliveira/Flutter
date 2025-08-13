import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Define um valor inicial para o tema (claro por padrão)
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tema Claro/Escuro',
      theme: _isDarkMode ? _darkTheme : _lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tema Claro/Escuro'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Altere o tema',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Switch(
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tema claro com cores e fontes customizadas
final ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  primaryColorLight: Colors.amber,
  textTheme: TextTheme(
    headlineLarge:
        TextStyle(fontFamily: 'Roboto', fontSize: 20, color: Colors.black),
    bodyLarge:
        TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.black87),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
);

// Tema escuro com cores e fontes customizadas
final ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey[850],
  primaryColorDark: Colors.teal,
  textTheme: TextTheme(
    headlineLarge:
        TextStyle(fontFamily: 'Roboto', fontSize: 20, color: Colors.white),
    bodyLarge:
        TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.white70),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[900],
    foregroundColor: Colors.white,
  ),
);
