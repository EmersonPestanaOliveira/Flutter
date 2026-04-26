import 'package:flutter/material.dart';
import '../../models/catalog_entry.dart';
import '../../playgrounds/material/pickers/date_picker_playground.dart';
import '../../playgrounds/material/pickers/time_picker_playground.dart';

const List<CatalogEntry> materialPickerEntries = [
  CatalogEntry(
    title: 'Date Picker',
    icon: Icons.date_range,
    pageBuilder: _date,
  ),
  CatalogEntry(
    title: 'Time Picker',
    icon: Icons.access_time,
    pageBuilder: _time,
  ),
];

Widget _date() => const DatePickerPlayground();
Widget _time() => const TimePickerPlayground();
