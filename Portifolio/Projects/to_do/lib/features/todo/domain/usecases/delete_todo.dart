import 'package:todo_app/core/usecases/usecase.dart';
import 'package:todo_app/core/utils/result.dart';
import 'package:todo_app/features/todo/domain/repositories/todo_repository.dart';

class DeleteTodo implements UseCase<void, int> {
  final TodoRepository repo;
  DeleteTodo(this.repo);

  @override
  Future<Result<void>> call(int id) => repo.delete(id);
}
