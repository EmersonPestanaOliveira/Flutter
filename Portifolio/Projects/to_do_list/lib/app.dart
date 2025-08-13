import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/task_controller.dart';
import 'services/database_service.dart';
import 'views/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Aqui injetamos o DatabaseService e o TaskController
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
        ChangeNotifierProvider<TaskController>(
          create: (context) => TaskController(
            Provider.of<DatabaseService>(context, listen: false),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'To-Do List',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomePage(),
      ),
    );
  }
}
