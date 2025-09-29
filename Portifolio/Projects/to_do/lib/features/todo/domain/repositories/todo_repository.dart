import 'package:todo_app/core/utils/result.dart';
import 'package:todo_app/features/todo/domain/entities/todo.dart';

abstract class TodoRepository {
  Future<Result<List<Todo>>> getAll();
  Future<Result<Todo>> add(Todo todo);
  Future<Result<Todo>> update(Todo todo);
  Future<Result<void>> delete(int id);
  Future<Result<Todo>> toggle(int id);
}
