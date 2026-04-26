import 'package:flutter/material.dart';
import '../../models/catalog_entry.dart';
import '../../playgrounds/material/feedback/circular_progress_playground.dart';
import '../../playgrounds/material/feedback/custom_progress_playground.dart';
import '../../playgrounds/material/feedback/linear_progress_playground.dart';
import '../../playgrounds/material/feedback/notifier_playground.dart';
import '../../playgrounds/material/feedback/snackbar_playground.dart';
import '../../playgrounds/material/feedback/spotlight_playground.dart';
import '../../playgrounds/material/feedback/state_progress_bar_playground.dart';

const List<CatalogEntry> materialFeedbackEntries = [
  CatalogEntry(
    title: 'Circular Progress',
    icon: Icons.autorenew,
    pageBuilder: _circular,
  ),
  CatalogEntry(
    title: 'Custom Progress',
    icon: Icons.equalizer,
    pageBuilder: _custom,
  ),
  CatalogEntry(
    title: 'Linear Progressbar',
    icon: Icons.linear_scale,
    pageBuilder: _linear,
  ),
  CatalogEntry(
    title: 'Notifier',
    icon: Icons.notifications,
    pageBuilder: _notifier,
  ),
  CatalogEntry(
    title: 'Snackbar',
    icon: Icons.view_headline,
    pageBuilder: _snackbar,
  ),
  CatalogEntry(
    title: 'Spotlight',
    icon: Icons.lightbulb,
    pageBuilder: _spotlight,
  ),
  CatalogEntry(
    title: 'State Progress Bar',
    icon: Icons.done_all,
    pageBuilder: _state,
  ),
];

Widget _circular() => const CircularProgressPlayground();
Widget _custom() => const CustomProgressPlayground();
Widget _linear() => const LinearProgressPlayground();
Widget _notifier() => const NotifierPlayground();
Widget _snackbar() => const SnackBarPlayground();
Widget _spotlight() => const SpotlightPlayground();
Widget _state() => const StateProgressBarPlayground();
