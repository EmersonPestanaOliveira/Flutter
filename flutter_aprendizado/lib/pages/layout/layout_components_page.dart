import 'package:flutter/material.dart';
import '../../data/layout/layout_entries.dart';
import '../catalog/category_grid_page.dart';

class LayoutComponentsPage extends StatelessWidget {
  const LayoutComponentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryGridPage(
      title: 'Layout',
      entries: layoutEntries,
    );
  }
}
