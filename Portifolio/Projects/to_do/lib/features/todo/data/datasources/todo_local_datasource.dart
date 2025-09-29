import 'package:sqflite/sqflite.dart';
import 'package:todo_app/core/database/app_database.dart';
import 'package:todo_app/features/todo/data/models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getAll();
  Future<TodoModel> add(TodoModel todo);
  Future<TodoModel> update(TodoModel todo);
  Future<void> delete(int id);
  Future<TodoModel> toggle(int id);
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  Future<Database> get _db async => AppDatabase.instance();

  @override
  Future<List<TodoModel>> getAll() async {
    final db = await _db;
    final res = await db.query('todos', orderBy: 'created_at DESC');
    return res.map((e) => TodoModel.fromMap(e)).toList();
  }

  @override
  Future<TodoModel> add(TodoModel todo) async {
    final db = await _db;
    final id = await db.insert('todos', todo.toMap());
    return todo.copyWith(id: id);
  }

  @override
  Future<TodoModel> update(TodoModel todo) async {
    final db = await _db;
    await db.update('todos', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
    return todo;
  }

  @override
  Future<void> delete(int id) async {
    final db = await _db;
    await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<TodoModel> toggle(int id) async {
    final db = await _db;
    final rows = await db.query('todos', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) throw Exception('Todo not found');
    final current = TodoModel.fromMap(rows.first);
    final updated = current.copyWith(done: !current.done);
    await db.update('todos', updated.toMap(), where: 'id = ?', whereArgs: [id]);
    return updated;
    }
}
