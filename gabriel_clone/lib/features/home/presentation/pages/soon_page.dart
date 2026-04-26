import 'package:flutter/material.dart';

import '../../../../core/widgets/app_scaffold.dart';

class SoonPage extends StatelessWidget {
  const SoonPage({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: title,
      body: const Center(child: Text('em breve')),
    );
  }
}