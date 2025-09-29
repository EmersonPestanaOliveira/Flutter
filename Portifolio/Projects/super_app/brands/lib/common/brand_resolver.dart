import 'package:flutter/material.dart';
import '../brand_acme/theme.dart' as acme;
import '../brand_beta/theme.dart' as beta;
import 'brand_key.dart';

ThemeData brandTheme(BrandKey key, Brightness brightness) {
  switch (key) {
    case BrandKey.acme:
      return acme.buildAcmeTheme(brightness);
    case BrandKey.beta:
      return beta.buildBetaTheme(brightness);
  }
}

/// Se quiser padronizar o caminho de assets por brand (opcional)
String brandAsset(BrandKey key, String relPath) =>
    'packages/brands/assets/${key.name}/$relPath';
