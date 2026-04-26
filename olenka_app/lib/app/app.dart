import 'package:flutter/material.dart';

import '../design_system/theme/app_theme.dart';
import 'app_router.dart';

class OlenkaApp extends StatelessWidget {
  const OlenkaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Olenka Estetica',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}