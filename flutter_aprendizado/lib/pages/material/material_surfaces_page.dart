import 'package:flutter/material.dart';
import '../../data/material/surface_entries.dart';
import '../catalog/category_grid_page.dart';

class MaterialSurfacesPage extends StatelessWidget {
  const MaterialSurfacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryGridPage(
      title: 'Material / SuperfÃ­cie',
      entries: materialSurfaceEntries,
    );
  }
}
