import 'package:flutter/material.dart';
import '../../models/catalog_entry.dart';
import '../../playgrounds/material/selection/checkbox_playground.dart';
import '../../playgrounds/material/selection/list_picker_playground.dart';
import '../../playgrounds/material/selection/radio_playground.dart';
import '../../playgrounds/material/selection/rating_bar_playground.dart';
import '../../playgrounds/material/selection/switch_playground.dart';

const List<CatalogEntry> materialSelectionEntries = [
  CatalogEntry(
    title: 'Checkbox',
    icon: Icons.check_box,
    pageBuilder: _checkbox,
  ),
  CatalogEntry(
    title: 'List Picker',
    icon: Icons.list_alt,
    pageBuilder: _listPicker,
  ),
  CatalogEntry(
    title: 'Radio Button',
    icon: Icons.radio_button_checked,
    pageBuilder: _radio,
  ),
  CatalogEntry(
    title: 'Rating Bar',
    icon: Icons.star_border,
    pageBuilder: _rating,
  ),
  CatalogEntry(
    title: 'Switch',
    icon: Icons.toggle_on,
    pageBuilder: _switch,
  ),
];

Widget _checkbox() => const CheckboxPlayground();
Widget _listPicker() => const ListPickerPlayground();
Widget _radio() => const RadioPlayground();
Widget _rating() => const RatingBarPlayground();
Widget _switch() => const SwitchPlayground();
