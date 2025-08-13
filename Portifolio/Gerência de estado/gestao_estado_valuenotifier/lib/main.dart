import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: CrudApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class CrudApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD com ValueNotifier'),
        centerTitle: true,
      ),
      body: TaskManager(),
    );
  }
}

class TaskManager extends StatelessWidget {
  final ValueNotifier<List<String>> tasks = ValueNotifier<List<String>>([]);
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    if (_controller.text.isNotEmpty) {
      tasks.value = [...tasks.value, _controller.text];
      _controller.clear();
    }
  }

  void _editTask(int index, BuildContext context) {
    _controller.text = tasks.value[index];
    showDialog(
      context: context, // Use o contexto fornecido pelo Flutter
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Tarefa'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Digite a nova tarefa'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final updatedTasks = List<String>.from(tasks.value);
                updatedTasks[index] = _controller.text;
                tasks.value = updatedTasks;
                _controller.clear();
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(int index) {
    final updatedTasks = List<String>.from(tasks.value);
    updatedTasks.removeAt(index);
    tasks.value = updatedTasks;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Adicione uma tarefa',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addTask,
                child: Text('Adicionar'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ValueListenableBuilder<List<String>>(
            valueListenable: tasks,
            builder: (context, taskList, child) {
              if (taskList.isEmpty) {
                return Center(child: Text('Nenhuma tarefa adicionada.'));
              }
              return ListView.builder(
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: ListTile(
                      title: Text(taskList[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editTask(index, context),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTask(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
