// base_app/lib/brand_bootstrap.dart
import 'package:brands/brands.dart';

BrandKey resolveBrandFromEnv() {
  const name = String.fromEnvironment('BRAND', defaultValue: 'acme');
  return BrandKey.values.firstWhere(
    (b) => b.name == name,
    orElse: () => BrandKey.acme,
  );
}
