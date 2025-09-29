import 'package:equatable/equatable.dart';
import 'package:todo_app/features/todo/domain/entities/todo.dart';

enum TodoStatus { initial, loading, success, failure }

class TodoState extends Equatable {
  final TodoStatus status;
  final List<Todo> items;
  final String? error;

  const TodoState({
    required this.status,
    required this.items,
    required this.error,
  });

  const TodoState.initial()
      : status = TodoStatus.initial,
        items = const [],
        error = null;

  TodoState copyWith({
    TodoStatus? status,
    List<Todo>? items,
    String? error,
  }) {
    return TodoState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, items, error];
}
