import 'package:get_it/get_it.dart';
import 'package:todo_app/features/todo/data/datasources/todo_local_datasource.dart';
import 'package:todo_app/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:todo_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:todo_app/features/todo/domain/usecases/add_todo.dart';
import 'package:todo_app/features/todo/domain/usecases/delete_todo.dart';
import 'package:todo_app/features/todo/domain/usecases/get_todos.dart';
import 'package:todo_app/features/todo/domain/usecases/toggle_todo.dart';
import 'package:todo_app/features/todo/domain/usecases/update_todo.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // Data sources
  sl.registerLazySingleton<TodoLocalDataSource>(() => TodoLocalDataSourceImpl());

  // Repositories
  sl.registerLazySingleton<TodoRepository>(() => TodoRepositoryImpl(sl()));

  // Usecases
  sl
    ..registerLazySingleton(() => GetTodos(sl()))
    ..registerLazySingleton(() => AddTodo(sl()))
    ..registerLazySingleton(() => UpdateTodo(sl()))
    ..registerLazySingleton(() => DeleteTodo(sl()))
    ..registerLazySingleton(() => ToggleTodo(sl()));
}
