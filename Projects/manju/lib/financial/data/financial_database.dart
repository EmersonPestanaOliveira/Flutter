import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FinancialDatabase {
  static final FinancialDatabase instance = FinancialDatabase._init();

  static Database? _database;

  FinancialDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('financial.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        value REAL NOT NULL,
        dateTime TEXT NOT NULL,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE debts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        totalValue REAL NOT NULL,
        paidValue REAL NOT NULL
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
