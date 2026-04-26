import 'package:flutter/material.dart';
import '../../models/catalog_entry.dart';
import '../../playgrounds/material/inputs/slider_playground.dart';
import '../../playgrounds/material/inputs/spinner_playground.dart';
import '../../playgrounds/material/inputs/text_box_playground.dart';
import '../../playgrounds/material/inputs/text_field_playground.dart';

const List<CatalogEntry> materialInputEntries = [
  CatalogEntry(
    title: 'TextField',
    icon: Icons.text_fields,
    pageBuilder: _textField,
  ),
  CatalogEntry(
    title: 'Text Box',
    icon: Icons.notes,
    pageBuilder: _textBox,
  ),
  CatalogEntry(
    title: 'Slider',
    icon: Icons.tune,
    pageBuilder: _slider,
  ),
  CatalogEntry(
    title: 'Spinner',
    icon: Icons.arrow_drop_down_circle,
    pageBuilder: _spinner,
  ),
];

Widget _textField() => const TextFieldPlayground();
Widget _textBox() => const TextBoxPlayground();
Widget _slider() => const SliderPlayground();
Widget _spinner() => const SpinnerPlayground();
