// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:todo_app_provider/todo_apiservice.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> tasks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedTasks = await apiService.fetchTasks();
      setState(() {
        tasks = fetchedTasks;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching tasks: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load tasks')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addTask(String title) async {
    try {
      final newTask = await apiService.createTask(title, false);
      setState(() {
        tasks.add(newTask);
      });
    } catch (e) {
      print('Error adding task: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add task')),
      );
    }
  }

  Future<void> _editTask(String id, String title, bool completed) async {
    final taskIndex = tasks.indexWhere((task) => task['_id'] == id);
    if (taskIndex == -1) return;

    final oldTask = Map<String, dynamic>.from(tasks[taskIndex]);

    setState(() {
      tasks[taskIndex] = {
        ...tasks[taskIndex],
        'title': title,
        'completed': completed,
      };
    });

    try {
      final updatedTask = await apiService.updateTask(id, title, completed);
      setState(() {
        tasks[taskIndex] = updatedTask;
      });
    } catch (e) {
      print('Error editing task: $e');
      setState(() {
        tasks[taskIndex] = oldTask;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update task')),
      );
    }
  }

  Future<void> _toggleTaskCompletion(String id, String title, bool completed) async {
    await _editTask(id, title, !completed);
  }

  Future<void> _deleteTask(String id) async {
    final taskIndex = tasks.indexWhere((task) => task['_id'] == id);
    if (taskIndex == -1) return;

    final deletedTask = tasks[taskIndex];
    setState(() {
      tasks.removeAt(taskIndex);
    });

    try {
      await apiService.hardDeleteTask(id);
    } catch (e) {
      print('Error deleting task: $e');
      setState(() {
        tasks.insert(taskIndex, deletedTask);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete task')),
      );
    }
  }

  void _showAddTaskDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Task Title'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = controller.text.trim();
                if (title.isNotEmpty) {
                  _addTask(title);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTaskDialog(String id, String currentTitle, bool completed) {
    final TextEditingController controller = TextEditingController(text: currentTitle);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Task Title'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newTitle = controller.text.trim();
                if (newTitle.isNotEmpty) {
                  _editTask(id, newTitle, completed);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTasks,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
              ? const Center(
                  child: Text(
                    'No tasks available',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Card(
                      color: const Color(0xFF1E1E2C),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        title: Text(
                          task['title'],
                          style: TextStyle(
                            fontSize: 18,
                            decoration:
                                task['completed'] ? TextDecoration.lineThrough : null,
                            color: Colors.white,
                          ),
                        ),
                        leading: Checkbox(
                          value: task['completed'],
                          onChanged: (bool? value) {
                            if (value != null) {
                              _toggleTaskCompletion(
                                task['_id'],
                                task['title'],
                                task['completed'],
                              );
                            }
                          },
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.deepPurpleAccent),
                              onPressed: () {
                                _showEditTaskDialog(
                                  task['_id'],
                                  task['title'],
                                  task['completed'],
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.greenAccent),
                              onPressed: () => _deleteTask(task['_id']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Colors.tealAccent,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
