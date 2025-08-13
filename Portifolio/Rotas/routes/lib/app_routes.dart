import 'package:flutter/material.dart';
import 'screens/simple_screen.dart';
import 'screens/pass_value_screen.dart';
import 'screens/named_route_screen.dart';
import 'screens/tab_screen.dart';
import 'screens/home_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => HomeScreen(),
  '/simple': (context) => SimpleScreen(),
  '/pass-value': (context) => PassValueScreen(data: 'Exemplo de Dados'),
  '/named-route': (context) => NamedRouteScreen(),
  '/tabs': (context) => TabScreen(),
};
