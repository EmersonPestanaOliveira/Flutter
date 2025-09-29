import 'package:todo_app/core/utils/result.dart';
import 'package:todo_app/features/todo/data/datasources/todo_local_datasource.dart';
import 'package:todo_app/features/todo/data/models/todo_model.dart';
import 'package:todo_app/features/todo/domain/entities/todo.dart';
import 'package:todo_app/features/todo/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource local;
  TodoRepositoryImpl(this.local);

  @override
  Future<Result<List<Todo>>> getAll() async {
    try {
      final list = await local.getAll();
      return Success<List<Todo>>(list);
    } catch (e) {
      return Fail<List<Todo>>(e);
    }
  }

  @override
  Future<Result<Todo>> add(Todo todo) async {
    try {
      final created = await local.add(_toModel(todo));
      return Success<Todo>(created);
    } catch (e) {
      return Fail<Todo>(e);
    }
  }

  @override
  Future<Result<Todo>> update(Todo todo) async {
    try {
      final updated = await local.update(_toModel(todo));
      return Success<Todo>(updated);
    } catch (e) {
      return Fail<Todo>(e);
    }
  }

  @override
  Future<Result<void>> delete(int id) async {
    try {
      await local.delete(id);
      return const Success<void>(null);
    } catch (e) {
      return Fail<void>(e);
    }
  }

  @override
  Future<Result<Todo>> toggle(int id) async {
    try {
      final toggled = await local.toggle(id);
      return Success<Todo>(toggled);
    } catch (e) {
      return Fail<Todo>(e);
    }
  }

  TodoModel _toModel(Todo e) => TodoModel(
        id: e.id,
        title: e.title,
        description: e.description,
        done: e.done,
        createdAt: e.createdAt,
      );
}
