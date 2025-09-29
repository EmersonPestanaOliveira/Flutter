import 'package:todo_app/features/todo/domain/entities/todo.dart';

class TodoModel extends Todo {
  const TodoModel({
    super.id,
    required super.title,
    super.description,
    super.done = false,
    required super.createdAt,
  });

  factory TodoModel.fromMap(Map<String, Object?> map) {
    return TodoModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
      done: (map['done'] as int) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'done': done ? 1 : 0,
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  TodoModel copyWith({
    int? id,
    String? title,
    String? description,
    bool? done,
    DateTime? createdAt,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      done: done ?? this.done,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
