import 'package:flutter/material.dart';
import '../../data/material/input_entries.dart';
import '../catalog/category_grid_page.dart';

class MaterialInputsPage extends StatelessWidget {
  const MaterialInputsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryGridPage(
      title: 'Material / Inputs',
      entries: materialInputEntries,
    );
  }
}
