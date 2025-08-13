import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';

class TaskController extends ChangeNotifier {
  final DatabaseService _databaseService;

  // Lista em memória das tarefas
  List<TaskModel> tasks = [];

  TaskController(this._databaseService);

  // Ler todas as tarefas do banco
  Future<void> loadTasks() async {
    tasks = await _databaseService.readAllTasks();
    notifyListeners();
  }

  // Criar nova tarefa
  Future<void> createTask(TaskModel task) async {
    await _databaseService.createTask(task);
    await loadTasks();
  }

  // Atualizar tarefa (title, description ou isDone)
  Future<void> updateTask(TaskModel task) async {
    await _databaseService.updateTask(task);
    await loadTasks();
  }

  // Excluir tarefa
  Future<void> deleteTask(int id) async {
    await _databaseService.deleteTask(id);
    await loadTasks();
  }

  // Marcar como concluída ou não
  Future<void> toggleTaskDone(TaskModel task) async {
    task.isDone = !task.isDone;
    await _databaseService.updateTask(task);
    await loadTasks();
  }
}
