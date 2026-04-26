import 'package:flutter/material.dart';
import '../../data/root/ui_root_entries.dart';
import '../catalog/category_grid_page.dart';

class UIComponentsPage extends StatelessWidget {
  const UIComponentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryGridPage(
      title: 'UI Components',
      entries: uiRootEntries,
    );
  }
}
