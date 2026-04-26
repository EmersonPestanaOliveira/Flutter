import 'package:flutter/material.dart';
import '../../models/catalog_entry.dart';
import '../../playgrounds/material/buttons/dropdown_menu_playground.dart';
import '../../playgrounds/material/buttons/elevated_button_playground.dart';
import '../../playgrounds/material/buttons/fab_playground.dart';
import '../../playgrounds/material/buttons/filled_button_playground.dart';
import '../../playgrounds/material/buttons/filled_tonal_button_playground.dart';
import '../../playgrounds/material/buttons/icon_button_playground.dart';
import '../../playgrounds/material/buttons/outlined_button_playground.dart';
import '../../playgrounds/material/buttons/text_button_playground.dart';

const List<CatalogEntry> materialButtonEntries = [
  CatalogEntry(
    title: 'ElevatedButton',
    icon: Icons.smart_button,
    pageBuilder: _elevated,
  ),
  CatalogEntry(
    title: 'FilledButton',
    icon: Icons.rectangle,
    pageBuilder: _filled,
  ),
  CatalogEntry(
    title: 'FilledButton Tonal',
    icon: Icons.rectangle_outlined,
    pageBuilder: _filledTonal,
  ),
  CatalogEntry(
    title: 'OutlinedButton',
    icon: Icons.crop_square,
    pageBuilder: _outlined,
  ),
  CatalogEntry(
    title: 'TextButton',
    icon: Icons.text_fields,
    pageBuilder: _textButton,
  ),
  CatalogEntry(
    title: 'IconButton',
    icon: Icons.ads_click,
    pageBuilder: _iconButton,
  ),
  CatalogEntry(
    title: 'Floating Action Button',
    icon: Icons.add_circle,
    pageBuilder: _fab,
  ),
  CatalogEntry(
    title: 'DropdownMenu',
    icon: Icons.arrow_drop_down_circle,
    pageBuilder: _dropdown,
  ),
];

Widget _elevated() => const ElevatedButtonPlayground();
Widget _filled() => const FilledButtonPlayground();
Widget _filledTonal() => const FilledTonalButtonPlayground();
Widget _outlined() => const OutlinedButtonPlayground();
Widget _textButton() => const TextButtonPlayground();
Widget _iconButton() => const IconButtonPlayground();
Widget _fab() => const FabPlayground();
Widget _dropdown() => const DropdownMenuPlayground();
