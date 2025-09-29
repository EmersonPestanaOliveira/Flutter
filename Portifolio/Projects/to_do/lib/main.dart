import 'package:flutter/material.dart';
import 'package:todo_app/app/app.dart';

Future<void> main() async {
  // Inicializa Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Roda o app
  runApp(const App());
}
