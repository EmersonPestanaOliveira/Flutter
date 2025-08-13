import 'package:flutter/material.dart';
import 'package:nasa/injection/injection.dart';
import 'package:nasa/presentation/pages/home_page.dart';
import 'package:nasa/presentation/providers/image_provider.dart';
import 'package:provider/provider.dart';

void main() {
  setupInjector();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ImageChangeNotifier>(
          create: (_) => getIt<ImageChangeNotifier>(),
        ),
      ],
      child: MaterialApp(
        title: 'Nasa App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomePage(),
      ),
    );
  }
}
