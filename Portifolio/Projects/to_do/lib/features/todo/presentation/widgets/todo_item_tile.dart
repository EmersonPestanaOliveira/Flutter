import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/todo/domain/entities/todo.dart';
import 'package:todo_app/features/todo/presentation/cubit/todo_cubit.dart';

/// Versão “neo” do item, no estilo da UI de referência.
class TodoItemTileNeo extends StatelessWidget {
  const TodoItemTileNeo({super.key, required this.todo});
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    final isDone = todo.done;
    final colorPrimary = const Color(0xFF6C63FF);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => context.read<TodoCubit>().toggle(todo.id!),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 6)),
          ],
          border: Border.all(
              color: isDone
                  ? colorPrimary.withOpacity(0.25)
                  : const Color(0x11000000)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            _NeoCheckbox(
              value: isDone,
              onChanged: (_) => context.read<TodoCubit>().toggle(todo.id!),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                      color: const Color(0xFF20232A),
                    ),
                  ),
                  if (todo.description != null &&
                      todo.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      todo.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF6B7280)),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: const [
                      Icon(Icons.chat_bubble_outline,
                          size: 16, color: Color(0xFF9CA3AF)),
                      SizedBox(width: 4),
                      Text('Comments',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xFF9CA3AF))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () => context.read<TodoCubit>().remove(todo.id!),
              icon: const Icon(Icons.delete_outline, color: Color(0xFF9CA3AF)),
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}

class _NeoCheckbox extends StatelessWidget {
  const _NeoCheckbox({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorPrimary = const Color(0xFF6C63FF);
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: value ? colorPrimary : const Color(0xFFCBD5E1), width: 2),
        color: value ? colorPrimary : Colors.transparent,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onChanged(!value),
        child: value
            ? const Icon(Icons.check, size: 18, color: Colors.white)
            : const SizedBox.shrink(),
      ),
    );
  }
}
