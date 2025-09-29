import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app/app/dependency_injection/injector.dart';
import 'package:todo_app/features/todo/domain/usecases/add_todo.dart';
import 'package:todo_app/features/todo/domain/usecases/delete_todo.dart';
import 'package:todo_app/features/todo/domain/usecases/get_todos.dart';
import 'package:todo_app/features/todo/domain/usecases/toggle_todo.dart';
import 'package:todo_app/features/todo/domain/usecases/update_todo.dart';
import 'package:todo_app/features/todo/presentation/cubit/todo_cubit.dart';
import 'package:todo_app/features/todo/presentation/cubit/todo_state.dart';
import 'package:todo_app/features/todo/presentation/widgets/todo_item_tile.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cubit será criado no MultiBlocProvider (abaixo).
  }

  @override
  Widget build(BuildContext context) {
    final colorPrimary = const Color(0xFF6C63FF); // roxo moderno
    final colorAccent = const Color(0xFF00E5FF); // neon

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TodoCubit(
            getTodos: sl<GetTodos>(),
            addTodo: sl<AddTodo>(),
            updateTodo: sl<UpdateTodo>(),
            deleteTodo: sl<DeleteTodo>(),
            toggleTodo: sl<ToggleTodo>(),
          )..load(),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        body: SafeArea(
          child: BlocBuilder<TodoCubit, TodoState>(
            builder: (context, state) {
              if (state.status == TodoStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == TodoStatus.failure) {
                return Center(child: Text(state.error ?? 'Erro'));
              }

              final items = state.items;
              final doneCount = items.where((e) => e.done).length;

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _HeaderBanner(
                      colorPrimary: colorPrimary,
                      colorAccent: colorAccent,
                      totalTasks: items.length,
                      doneTasks: doneCount,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: _SectionTitle(title: 'Today Task'),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList.separated(
                      itemCount: items.length,
                      itemBuilder: (_, i) => TodoItemTileNeo(todo: items[i]),
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 96)),
                ],
              );
            },
          ),
        ),

        // Botão chamativo como na referência
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 4,
              ),
              icon: const Icon(Icons.edit),
              label: const Text('Add New Task',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              onPressed: () =>
                  _showAddBottomSheet(context, titleCtrl, descCtrl),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddBottomSheet(
    BuildContext context,
    TextEditingController titleCtrl,
    TextEditingController descCtrl,
  ) async {
    final todoCubit = context.read<TodoCubit>(); // captura do contexto correto

    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: false, // importante com GoRouter/navigator aninhado
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        // reexpõe o mesmo cubit dentro do bottom sheet
        return BlocProvider.value(
          value: todoCubit,
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 20,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 16),
                const Text('New Task',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description (optional)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: () {
                      final title = titleCtrl.text.trim();
                      final desc = descCtrl.text.trim().isEmpty
                          ? null
                          : descCtrl.text.trim();
                      if (title.isEmpty) return;

                      // aqui o Provider/TodoCubit é encontrado com segurança
                      sheetCtx.read<TodoCubit>().add(title, description: desc);

                      titleCtrl.clear();
                      descCtrl.clear();
                      Navigator.pop(sheetCtx);
                    },
                    child: const Text('Add Task',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// banner superior inspirado na referência (gradiente, avatars e SVG à direita)
class _HeaderBanner extends StatelessWidget {
  const _HeaderBanner({
    required this.colorPrimary,
    required this.colorAccent,
    required this.totalTasks,
    required this.doneTasks,
  });

  final Color colorPrimary;
  final Color colorAccent;
  final int totalTasks;
  final int doneTasks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        height: 170,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorPrimary, colorAccent.withOpacity(0.65)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
                color: Color(0x266C63FF), blurRadius: 16, offset: Offset(0, 8)),
          ],
        ),
        child: Stack(
          children: [
            // texto
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 180, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Planning\nYour Day',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                )),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _Avatar(
                            color: Colors.white.withOpacity(0.9),
                            icon: Icons.person),
                        const SizedBox(width: 6),
                        _Avatar(color: Colors.white70, icon: Icons.person),
                        const SizedBox(width: 6),
                        _Avatar(color: Colors.white54, icon: Icons.person),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.22),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text('+3',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 62),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CircleAvatar(
                                radius: 14, // era 16
                                backgroundColor: Color(0xFFEDEAFF),
                                child: Icon(Icons.folder_open_rounded,
                                    color: Color(0xFF6C63FF), size: 18),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Total $totalTasks Tasks',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2A2A2A),
                                    height: 1.1, // reduz a altura de linha
                                  ),
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded,
                                  color: Color(0xFF6C63FF), size: 22),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // SVG “mascote” à direita
            Positioned(
              right: 8,
              bottom: 0,
              top: 0,
              child: Opacity(
                opacity: 0.95,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/logo/todo_sci_fi.svg',
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.color, required this.icon});
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: color,
      child: Icon(icon, size: 16, color: const Color(0xFF6C63FF)),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF20232A))),
        const SizedBox(width: 8),
        Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
                color: Color(0xFF6C63FF), shape: BoxShape.circle)),
      ],
    );
  }
}
