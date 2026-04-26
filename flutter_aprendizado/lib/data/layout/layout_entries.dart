import 'package:flutter/material.dart';
import '../../models/catalog_entry.dart';
import '../../playgrounds/layout/container_playground.dart';
import '../../playgrounds/layout/row_playground.dart';

const List<CatalogEntry> layoutEntries = [
  CatalogEntry(
    title: 'Container',
    icon: Icons.crop_square,
    pageBuilder: _container,
  ),
  CatalogEntry(
    title: 'Row',
    icon: Icons.view_week,
    pageBuilder: _row,
  ),
];

Widget _container() => const ContainerPlayground();
Widget _row() => const RowPlayground();
