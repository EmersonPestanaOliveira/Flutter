class TaskModel {
  final int? id;
  String title;
  String description;
  bool isDone;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    this.isDone = false,
  });

  // Converte de Map para TaskModel (usado pelo SQLite)
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      isDone: (map['isDone'] == 1),
    );
  }

  // Converte de TaskModel para Map (usado pelo SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone ? 1 : 0,
    };
  }
}
