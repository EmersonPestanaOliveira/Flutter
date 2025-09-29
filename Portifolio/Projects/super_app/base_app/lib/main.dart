import 'package:flutter/material.dart';
import 'package:brands/brands.dart'; // BrandKey
import 'package:micro_app_home/micro_app_home.dart';
import 'base_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final microApps = [MicroAppHome()];
  final mergedRoutes = <String, WidgetBuilder>{};
  for (final m in microApps) {
    mergedRoutes.addAll(m.routes);
  }

  // escolha a brand (fixo ou por --dart-define)
  const brandName = String.fromEnvironment('BRAND', defaultValue: 'acme');
  final brand = BrandKey.values.firstWhere(
    (b) => b.name == brandName,
    orElse: () => BrandKey.acme,
  );

  runApp(BaseApp(
    initialRoute: MicroAppHome().initialRoute,
    routes: mergedRoutes,
    brand: brand, // <- passa a BrandKey do package brands
  ));
}
