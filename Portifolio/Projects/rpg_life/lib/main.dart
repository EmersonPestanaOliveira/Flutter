import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repository.dart';
import 'presentation/cubit/daily_cubit.dart';
import 'presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = await ChecklistRepository.create();
  runApp(MyApp(repo: repo));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.repo});
  final ChecklistRepository repo;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repo,
      child: BlocProvider(
        create: (_) => DailyCubit(repo)..load(DateTime.now()),
        child: MaterialApp(
          title: 'Checklist XP',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
          ),
          home: const HomePage(),
        ),
      ),
    );
  }
}
