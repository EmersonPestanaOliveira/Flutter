// lib/data/models.dart

/// Tipos possíveis de tarefas
class TaskType {
  static const boolType = 'bool';
  static const number = 'number';
  static const time = 'time';
}

/// Representa uma tarefa configurada
class Task {
  final int? id;
  final String name;
  final String type; // 'bool' | 'number' | 'time'
  final String? unit; // ex: 'L', 'min', 'mg'
  final double? target; // meta para number
  final int xpPerCompletion;
  final bool isNegative; // tarefa de evitar (ex: não comer chocolate)
  final bool isActive;

  Task({
    this.id,
    required this.name,
    required this.type,
    this.unit,
    this.target,
    this.xpPerCompletion = 10,
    this.isNegative = false,
    this.isActive = true,
  });

  Task copyWith({
    int? id,
    String? name,
    String? type,
    String? unit,
    double? target,
    int? xpPerCompletion,
    bool? isNegative,
    bool? isActive,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      unit: unit ?? this.unit,
      target: target ?? this.target,
      xpPerCompletion: xpPerCompletion ?? this.xpPerCompletion,
      isNegative: isNegative ?? this.isNegative,
      isActive: isActive ?? this.isActive,
    );
  }

  factory Task.fromMap(Map<String, Object?> m) => Task(
        id: m['id'] as int?,
        name: m['name'] as String,
        type: m['type'] as String,
        unit: m['unit'] as String?,
        target: (m['target'] as num?)?.toDouble(),
        xpPerCompletion: (m['xp_per_completion'] as num).toInt(),
        isNegative: (m['is_negative'] as int) == 1,
        isActive: (m['is_active'] as int) == 1,
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'type': type,
        'unit': unit,
        'target': target,
        'xp_per_completion': xpPerCompletion,
        'is_negative': isNegative ? 1 : 0,
        'is_active': isActive ? 1 : 0,
      };
}

/// Representa uma entrada diária de uma tarefa
class DailyEntry {
  final int? id;
  final int taskId;
  final String date; // YYYY-MM-DD
  final int? boolValue; // 0 | 1
  final double? numericValue;
  final String? timeValue; // HH:mm
  final String? notes;
  final int xpEarned;
  final String updatedAt; // ISO8601

  DailyEntry({
    this.id,
    required this.taskId,
    required this.date,
    this.boolValue,
    this.numericValue,
    this.timeValue,
    this.notes,
    this.xpEarned = 0,
    required this.updatedAt,
  });

  DailyEntry copyWith({
    int? id,
    int? taskId,
    String? date,
    int? boolValue,
    double? numericValue,
    String? timeValue,
    String? notes,
    int? xpEarned,
    String? updatedAt,
  }) {
    return DailyEntry(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      date: date ?? this.date,
      boolValue: boolValue ?? this.boolValue,
      numericValue: numericValue ?? this.numericValue,
      timeValue: timeValue ?? this.timeValue,
      notes: notes ?? this.notes,
      xpEarned: xpEarned ?? this.xpEarned,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory DailyEntry.fromMap(Map<String, Object?> m) => DailyEntry(
        id: m['id'] as int?,
        taskId: (m['task_id'] as num).toInt(),
        date: m['date'] as String,
        boolValue: m['bool_value'] as int?,
        numericValue: (m['numeric_value'] as num?)?.toDouble(),
        timeValue: m['time_value'] as String?,
        notes: m['notes'] as String?,
        xpEarned: (m['xp_earned'] as num).toInt(),
        updatedAt: m['updated_at'] as String,
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'task_id': taskId,
        'date': date,
        'bool_value': boolValue,
        'numeric_value': numericValue,
        'time_value': timeValue,
        'notes': notes,
        'xp_earned': xpEarned,
        'updated_at': updatedAt,
      };
}

/// Combina uma tarefa com a entrada diária correspondente
class DailyTaskView {
  final Task task;
  final DailyEntry entry;
  DailyTaskView({required this.task, required this.entry});
}

/// Helper para formatar a data como YYYY-MM-DD
String ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';
