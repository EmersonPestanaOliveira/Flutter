import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'dashboard.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        date TEXT,
        category TEXT,
        value REAL
      );
    ''');

    final now = DateTime.now();
    final List<Map<String, dynamic>> fakeData = [];

    // Hoje
    fakeData.add({
      'name': 'Venda #HOJE1',
      'date': now.toIso8601String().split('T').first,
      'category': 'Vendas',
      'value': 800.0,
    });

    // Últimos 7 dias
    for (int i = 1; i <= 3; i++) {
      final date = now.subtract(Duration(days: i));
      fakeData.add({
        'name': 'Venda #7DIAS$i',
        'date': date.toIso8601String().split('T').first,
        'category': 'Vendas',
        'value': 1000.0 + (i * 200),
      });
    }

    // Últimos 30 dias
    for (int i = 8; i <= 30; i += 5) {
      final date = now.subtract(Duration(days: i));
      fakeData.add({
        'name': 'Serviço #30DIAS$i',
        'date': date.toIso8601String().split('T').first,
        'category': 'Serviços',
        'value': 500.0 + (i * 10),
      });
    }

    for (final data in fakeData) {
      await db.insert('reports', data);
    }
  }

  static Future<List<Map<String, dynamic>>> fetchReports() async {
    final db = await database;
    return db.query('reports', orderBy: 'date DESC');
  }

  static Future<List<Map<String, dynamic>>> fetchReportsByPeriod(
      String period) async {
    final db = await database;

    String where = '';
    List<String> whereArgs = [];

    final now = DateTime.now();
    DateTime startDate;

    if (period == 'Hoje') {
      startDate = DateTime(now.year, now.month, now.day);
    } else if (period == 'Últimos 7 dias') {
      startDate = now.subtract(const Duration(days: 7));
    } else {
      // Últimos 30 dias
      startDate = now.subtract(const Duration(days: 30));
    }

    where = 'date(date) >= date(?)';
    whereArgs = [startDate.toIso8601String().split('T').first];

    return db.query(
      'reports',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'date ASC',
    );
  }

  static Future<Map<String, dynamic>> fetchDashboardStats() async {
    try {
      final db = await database;
      final result = await db.rawQuery('''
        SELECT 
          SUM(value) AS totalRevenue,
          COUNT(*) AS totalSales,
          COUNT(DISTINCT name) AS uniqueClients
        FROM reports;
      ''');

      return {
        'revenue': result.first['totalRevenue'] ?? 0,
        'sales': result.first['totalSales'] ?? 0,
        'clients': result.first['uniqueClients'] ?? 0,
      };
    } catch (e) {
      print('Erro ao buscar KPIs: $e');
      return {'revenue': 0, 'sales': 0, 'clients': 0};
    }
  }

  static Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'dashboard.db');
    await deleteDatabase(path);
  }
}
