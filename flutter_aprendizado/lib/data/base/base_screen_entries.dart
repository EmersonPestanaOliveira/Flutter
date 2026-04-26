import 'package:flutter/material.dart';
import '../../models/catalog_entry.dart';
import '../../playgrounds/base/login_screen_playground.dart';
import '../../playgrounds/base/profile_screen_playground.dart';

const List<CatalogEntry> baseScreenEntries = [
  CatalogEntry(
    title: 'Login Screen',
    icon: Icons.login,
    pageBuilder: _login,
  ),
  CatalogEntry(
    title: 'Profile Screen',
    icon: Icons.person,
    pageBuilder: _profile,
  ),
];

Widget _login() => const LoginScreenPlayground();
Widget _profile() => const ProfileScreenPlayground();
