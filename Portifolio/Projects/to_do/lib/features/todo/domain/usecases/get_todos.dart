import 'package:todo_app/core/usecases/usecase.dart';
import 'package:todo_app/core/utils/result.dart';
import 'package:todo_app/features/todo/domain/entities/todo.dart';
import 'package:todo_app/features/todo/domain/repositories/todo_repository.dart';

class GetTodos implements UseCase<List<Todo>, NoParams> {
  final TodoRepository repo;
  GetTodos(this.repo);

  @override
  Future<Result<List<Todo>>> call(NoParams params) => repo.getAll();
}
