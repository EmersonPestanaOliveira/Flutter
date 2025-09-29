import 'package:todo_app/core/usecases/usecase.dart';
import 'package:todo_app/core/utils/result.dart';
import 'package:todo_app/features/todo/domain/entities/todo.dart';
import 'package:todo_app/features/todo/domain/repositories/todo_repository.dart';

class ToggleTodo implements UseCase<Todo, int> {
  final TodoRepository repo;
  ToggleTodo(this.repo);

  @override
  Future<Result<Todo>> call(int id) => repo.toggle(id);
}
