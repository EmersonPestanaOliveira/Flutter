import 'package:todo_app/core/usecases/usecase.dart';
import 'package:todo_app/core/utils/result.dart';
import 'package:todo_app/features/todo/domain/entities/todo.dart';
import 'package:todo_app/features/todo/domain/repositories/todo_repository.dart';

class AddTodo implements UseCase<Todo, Todo> {
  final TodoRepository repo;
  AddTodo(this.repo);

  @override
  Future<Result<Todo>> call(Todo params) => repo.add(params);
}
