import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    // Diretório de documentos da aplicação (Android/iOS/Windows/macOS/Linux)
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'checklist_xp.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tabela de tarefas (configurações/base)
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            type TEXT NOT NULL,          -- 'bool' | 'number' | 'time'
            unit TEXT,                   -- ex: 'L', 'min', 'mg'
            target REAL,                 -- meta para number (ex: 1.0 L, 15 min)
            xp_per_completion INTEGER NOT NULL DEFAULT 10,
            is_negative INTEGER NOT NULL DEFAULT 0, -- 1 = tarefa "evitar"
            is_active INTEGER NOT NULL DEFAULT 1
          );
        ''');

        // Entradas diárias (uma linha por tarefa por data)
        await db.execute('''
          CREATE TABLE daily_entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            task_id INTEGER NOT NULL,
            date TEXT NOT NULL,          -- 'YYYY-MM-DD'
            bool_value INTEGER,          -- 0 | 1
            numeric_value REAL,          -- quantidade atual (para number)
            time_value TEXT,             -- 'HH:mm'
            notes TEXT,
            xp_earned INTEGER NOT NULL DEFAULT 0,
            updated_at TEXT NOT NULL,    -- ISO8601
            UNIQUE(task_id, date),
            FOREIGN KEY(task_id) REFERENCES tasks(id) ON DELETE CASCADE
          );
        ''');

        await db.execute('CREATE INDEX idx_entries_date ON daily_entries(date);');
      },
    );
  }
}
