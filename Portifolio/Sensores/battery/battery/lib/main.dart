import 'package:battery/view/battery_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const BatteryApp());

class BatteryApp extends StatelessWidget {
  const BatteryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nível de Bateria',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      home: const BatteryPage(),
    );
  }
}
