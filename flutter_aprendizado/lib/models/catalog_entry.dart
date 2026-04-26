import 'package:flutter/material.dart';

class CatalogEntry {
  final String title;
  final IconData icon;
  final Widget Function() pageBuilder;

  const CatalogEntry({
    required this.title,
    required this.icon,
    required this.pageBuilder,
  });
}
