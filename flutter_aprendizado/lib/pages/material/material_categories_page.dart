import 'package:flutter/material.dart';
import '../../data/material/material_category_entries.dart';
import '../catalog/category_grid_page.dart';

class MaterialCategoriesPage extends StatelessWidget {
  const MaterialCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryGridPage(
      title: 'Material',
      entries: materialCategoryEntries,
    );
  }
}
