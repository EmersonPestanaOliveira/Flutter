import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  Database? _db;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDB();
    }
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        isDone INTEGER
      )
    ''');
  }

  // Métodos de CRUD
  Future<int> createTask(TaskModel task) async {
    final database = await db;
    return await database.insert('tasks', task.toMap());
  }

  Future<List<TaskModel>> readAllTasks() async {
    final database = await db;
    final List<Map<String, dynamic>> maps = await database.query('tasks');
    return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
  }

  Future<int> updateTask(TaskModel task) async {
    final database = await db;
    return await database.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final database = await db;
    return await database.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
