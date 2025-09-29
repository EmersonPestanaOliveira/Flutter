import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final int? id;
  final String title;
  final String? description;
  final bool done;
  final DateTime createdAt;

  const Todo({
    this.id,
    required this.title,
    this.description,
    this.done = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, description, done, createdAt];
}
