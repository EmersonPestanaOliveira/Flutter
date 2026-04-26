import 'package:flutter/material.dart';
import '../../models/catalog_entry.dart';
import '../../pages/base/base_screens_page.dart';
import '../../pages/cupertino/cupertino_components_page.dart';
import '../../pages/layout/layout_components_page.dart';
import '../../pages/material/material_categories_page.dart';

const List<CatalogEntry> uiRootEntries = [
  CatalogEntry(
    title: 'Material',
    icon: Icons.widgets,
    pageBuilder: _materialPage,
  ),
  CatalogEntry(
    title: 'Cupertino',
    icon: Icons.phone_iphone,
    pageBuilder: _cupertinoPage,
  ),
  CatalogEntry(
    title: 'Layout',
    icon: Icons.grid_view,
    pageBuilder: _layoutPage,
  ),
  CatalogEntry(
    title: 'Telas Base',
    icon: Icons.web,
    pageBuilder: _basePage,
  ),
];

Widget _materialPage() => const MaterialCategoriesPage();
Widget _cupertinoPage() => const CupertinoComponentsPage();
Widget _layoutPage() => const LayoutComponentsPage();
Widget _basePage() => const BaseScreensPage();
