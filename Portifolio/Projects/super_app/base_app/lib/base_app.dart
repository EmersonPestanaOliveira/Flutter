import 'package:flutter/material.dart';
import 'package:brands/brands.dart'; // BrandKey e brandTheme()

class BaseApp extends StatelessWidget {
  final String initialRoute;
  final Map<String, WidgetBuilder> routes;
  final BrandKey brand; // <- usa o BrandKey do package brands

  const BaseApp({
    super.key,
    required this.initialRoute,
    required this.routes,
    required this.brand,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super App',
      theme: brandTheme(brand, Brightness.light),
      darkTheme: brandTheme(brand, Brightness.dark),
      initialRoute: initialRoute,
      routes: routes,
    );
  }
}
