import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AgendaDatabase {
  static final AgendaDatabase instance = AgendaDatabase._init();

  static Database? _database;

  AgendaDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('agenda.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE appointments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        clientId INTEGER NOT NULL,
        clientName TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        productId INTEGER NOT NULL,
        productName TEXT NOT NULL
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE appointments ADD COLUMN productId INTEGER NOT NULL DEFAULT 0',
      );
      await db.execute(
        'ALTER TABLE appointments ADD COLUMN productName TEXT NOT NULL DEFAULT ""',
      );
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
