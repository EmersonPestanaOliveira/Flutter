import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/models.dart';
import '../cubit/daily_cubit.dart';
import '../widgets/task_tiles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checklist XP'),
        actions: [
          IconButton(
            tooltip: 'Hoje',
            icon: const Icon(Icons.today),
            onPressed: () => context.read<DailyCubit>().load(DateTime.now()),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<DailyCubit, DailyState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            final df = DateFormat('dd/MM/yyyy');

            return Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () => context.read<DailyCubit>().prevDay(),
                    ),
                    Text(
                      df.format(state.date),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () => context.read<DailyCubit>().nextDay(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('XP do dia:', style: Theme.of(context).textTheme.titleMedium),
                      Chip(label: Text('${state.totalXp} XP')),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    itemCount: state.tasks.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final vt = state.tasks[i];
                      switch (vt.task.type) {
                        case TaskType.boolType:
                          return BoolTaskTile(view: vt);
                        case TaskType.number:
                          return NumberTaskTile(view: vt);
                        case TaskType.time:
                          return TimeTaskTile(view: vt);
                        default:
                          return ListTile(title: Text(vt.task.name));
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
