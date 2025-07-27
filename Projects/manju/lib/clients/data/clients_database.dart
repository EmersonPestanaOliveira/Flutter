import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ClientsDatabase {
  static final ClientsDatabase instance = ClientsDatabase._init();

  static Database? _database;

  ClientsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('clients.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE clients(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT NOT NULL,
        birthday TEXT,
        social TEXT
      )
    ''');
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');

    await deleteDatabase(path);
    print('Banco de dados apagado com sucesso');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
