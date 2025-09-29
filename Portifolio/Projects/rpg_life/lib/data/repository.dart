import 'package:sqflite/sqflite.dart';

import 'app_db.dart';
import 'models.dart';

class ChecklistRepository {
  ChecklistRepository(this._db);
  final Database _db;

  /// Cria o repositório, prepara o banco, semeia tarefas padrão e
  /// garante as entradas do dia atual.
  static Future<ChecklistRepository> create() async {
    final db = await AppDatabase.instance.database;
    final repo = ChecklistRepository(db);
    await repo._seedDefaultTasksIfNeeded();
    await repo.ensureDailyFor(DateTime.now());
    return repo;
  }

  // ------------------------------
  // Seeds / setup
  // ------------------------------
  Future<void> _seedDefaultTasksIfNeeded() async {
    final count = Sqflite.firstIntValue(
          await _db.rawQuery('SELECT COUNT(*) FROM tasks'),
        ) ??
        0;
    if (count > 0) return;

    // Tarefas iniciais baseadas na sua planilha
    final defaults = <Task>[
      Task(name: 'Acordei', type: TaskType.time, xpPerCompletion: 5),
      Task(
          name: 'Tomar água',
          type: TaskType.number,
          unit: 'L',
          target: 1.0,
          xpPerCompletion: 10),
      Task(
          name: 'Venlafaxina',
          type: TaskType.number,
          unit: 'mg',
          target: 150,
          xpPerCompletion: 10),
      Task(
          name: 'Tomar sol',
          type: TaskType.number,
          unit: 'min',
          target: 15,
          xpPerCompletion: 8),
      Task(
          name: 'Caminhada',
          type: TaskType.number,
          unit: 'min',
          target: 15,
          xpPerCompletion: 10),
      Task(
          name: 'Não chocolate',
          type: TaskType.boolType,
          xpPerCompletion: 5,
          isNegative: true),
      Task(
          name: 'Não iFood',
          type: TaskType.boolType,
          xpPerCompletion: 5,
          isNegative: true),
    ];

    final batch = _db.batch();
    for (final t in defaults) {
      batch.insert('tasks', t.toMap());
    }
    await batch.commit(noResult: true);
  }

  /// Gera (se não existirem) as entradas diárias para todas as tarefas ativas.
  Future<void> ensureDailyFor(DateTime date) async {
    final dateStr = ymd(date);
    final tasks = await _db.query('tasks', where: 'is_active = 1');

    final batch = _db.batch();
    for (final t in tasks) {
      final taskId = t['id'] as int;
      batch.insert(
        'daily_entries',
        {
          'task_id': taskId,
          'date': dateStr,
          'updated_at': DateTime.now().toIso8601String(),
          'xp_earned': 0,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await batch.commit(noResult: true);
  }

  // ------------------------------
  // Queries
  // ------------------------------

  /// Retorna a visão de tarefas+entradas do dia.
  Future<List<DailyTaskView>> getDaily(DateTime date) async {
    final dateStr = ymd(date);
    final rows = await _db.rawQuery('''
      SELECT e.*, 
             t.id as t_id, t.name, t.type, t.unit, t.target, 
             t.xp_per_completion, t.is_negative, t.is_active
      FROM daily_entries e
      JOIN tasks t ON t.id = e.task_id
      WHERE e.date = ? AND t.is_active = 1
      ORDER BY t.id ASC
    ''', [dateStr]);

    return rows.map((m) {
      final task = Task(
        id: m['t_id'] as int,
        name: m['name'] as String,
        type: m['type'] as String,
        unit: m['unit'] as String?,
        target: (m['target'] as num?)?.toDouble(),
        xpPerCompletion: (m['xp_per_completion'] as num).toInt(),
        isNegative: (m['is_negative'] as int) == 1,
        isActive: (m['is_active'] as int) == 1,
      );
      final entry = DailyEntry.fromMap(m);
      return DailyTaskView(task: task, entry: entry);
    }).toList();
  }

  Future<int> getTotalXp(String dateYmd) async {
    final row = await _db.rawQuery(
      'SELECT SUM(xp_earned) as total FROM daily_entries WHERE date = ?',
      [dateYmd],
    );
    return (row.first['total'] as num?)?.toInt() ?? 0;
  }

  // ------------------------------
  // Updates
  // ------------------------------

  Future<void> updateBool(int entryId, bool value) async {
    final vt = await _viewByEntryId(entryId);
    final xp =
        _computeXp(vt.task, vt.entry.copyWith(boolValue: value ? 1 : 0));
    await _db.update(
      'daily_entries',
      {
        'bool_value': value ? 1 : 0,
        'xp_earned': xp,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [entryId],
    );
  }

  Future<void> updateNumber(int entryId, double? value) async {
    final vt = await _viewByEntryId(entryId);
    final xp = _computeXp(vt.task, vt.entry.copyWith(numericValue: value));
    await _db.update(
      'daily_entries',
      {
        'numeric_value': value,
        'xp_earned': xp,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [entryId],
    );
  }

  Future<void> updateTime(int entryId, String? hhmm) async {
    final vt = await _viewByEntryId(entryId);
    final xp = _computeXp(vt.task, vt.entry.copyWith(timeValue: hhmm));
    await _db.update(
      'daily_entries',
      {
        'time_value': hhmm,
        'xp_earned': xp,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [entryId],
    );
  }

  // ------------------------------
  // Helpers internos
  // ------------------------------

  Future<DailyTaskView> _viewByEntryId(int entryId) async {
    final rows = await _db.rawQuery('''
      SELECT e.*, 
             t.id as t_id, t.name, t.type, t.unit, t.target, 
             t.xp_per_completion, t.is_negative, t.is_active
      FROM daily_entries e
      JOIN tasks t ON t.id = e.task_id
      WHERE e.id = ?
      LIMIT 1
    ''', [entryId]);

    final m = rows.first;
    final task = Task(
      id: m['t_id'] as int,
      name: m['name'] as String,
      type: m['type'] as String,
      unit: m['unit'] as String?,
      target: (m['target'] as num?)?.toDouble(),
      xpPerCompletion: (m['xp_per_completion'] as num).toInt(),
      isNegative: (m['is_negative'] as int) == 1,
      isActive: (m['is_active'] as int) == 1,
    );
    final entry = DailyEntry.fromMap(m);
    return DailyTaskView(task: task, entry: entry);
  }

  /// Regras de XP:
  /// - bool: marcado => XP cheio
  /// - number: proporcional à meta (cap 100%)
  /// - time: se existe hora definida => XP cheio
  int _computeXp(Task task, DailyEntry e) {
    switch (task.type) {
      case TaskType.boolType:
        final v = (e.boolValue ?? 0) == 1;
        return v ? task.xpPerCompletion : 0;
      case TaskType.number:
        final v = e.numericValue ?? 0.0;
        final tgt = task.target ?? 0.0;
        if (tgt <= 0) return 0;
        final ratio = (v / tgt).clamp(0.0, 1.0);
        return (ratio * task.xpPerCompletion).round();
      case TaskType.time:
        final ok = (e.timeValue != null && e.timeValue!.isNotEmpty);
        return ok ? task.xpPerCompletion : 0;
      default:
        return 0;
    }
  }
}
