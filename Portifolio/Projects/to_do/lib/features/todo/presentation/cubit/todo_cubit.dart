import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/usecases/usecase.dart';
import 'package:todo_app/features/todo/domain/entities/todo.dart';
import 'package:todo_app/features/todo/domain/usecases/add_todo.dart';
import 'package:todo_app/features/todo/domain/usecases/delete_todo.dart';
import 'package:todo_app/features/todo/domain/usecases/get_todos.dart';
import 'package:todo_app/features/todo/domain/usecases/toggle_todo.dart';
import 'package:todo_app/features/todo/domain/usecases/update_todo.dart';
import 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final GetTodos getTodos;
  final AddTodo addTodo;
  final UpdateTodo updateTodo;
  final DeleteTodo deleteTodo;
  final ToggleTodo toggleTodo;

  TodoCubit({
    required this.getTodos,
    required this.addTodo,
    required this.updateTodo,
    required this.deleteTodo,
    required this.toggleTodo,
  }) : super(const TodoState.initial());

  Future<void> load() async {
    emit(state.copyWith(status: TodoStatus.loading));
    final res = await getTodos(const NoParams());
    res.when(
      success: (data) => emit(state.copyWith(status: TodoStatus.success, items: data)),
      failure: (e) => emit(state.copyWith(status: TodoStatus.failure, error: e.toString())),
    );
  }

  Future<void> add(String title, {String? description}) async {
    final todo = Todo(title: title, description: description, createdAt: DateTime.now());
    final res = await addTodo(todo);
    res.when(
      success: (_) => load(),
      failure: (e) => emit(state.copyWith(status: TodoStatus.failure, error: e.toString())),
    );
  }

  Future<void> toggle(int id) async {
    final res = await toggleTodo(id);
    res.when(
      success: (_) => load(),
      failure: (e) => emit(state.copyWith(status: TodoStatus.failure, error: e.toString())),
    );
  }

  Future<void> edit(Todo todo) async {
    final res = await updateTodo(todo);
    res.when(
      success: (_) => load(),
      failure: (e) => emit(state.copyWith(status: TodoStatus.failure, error: e.toString())),
    );
  }

  Future<void> remove(int id) async {
    final res = await deleteTodo(id);
    res.when(
      success: (_) => load(),
      failure: (e) => emit(state.copyWith(status: TodoStatus.failure, error: e.toString())),
    );
  }
}
