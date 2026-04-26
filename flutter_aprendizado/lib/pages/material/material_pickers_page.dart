import 'package:flutter/material.dart';
import '../../data/material/picker_entries.dart';
import '../catalog/category_grid_page.dart';

class MaterialPickersPage extends StatelessWidget {
  const MaterialPickersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryGridPage(
      title: 'Material / Pickers',
      entries: materialPickerEntries,
    );
  }
}
