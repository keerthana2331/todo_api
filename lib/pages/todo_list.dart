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
        SnackBar(content: Text('Failed to load tasks')),
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
        SnackBar(content: Text('Failed to add task')),
      );
    }
  }

  Future<void> _editTask(String id, String title, bool completed) async {
    // Find the task index
    final taskIndex = tasks.indexWhere((task) => task['_id'] == id);
    if (taskIndex == -1) return;

    // Store the old task data in case we need to revert
    final oldTask = Map<String, dynamic>.from(tasks[taskIndex]);

    // Update locally first
    setState(() {
      tasks[taskIndex] = {
        ...tasks[taskIndex],
        'title': title,
        'completed': completed,
      };
    });

    try {
      // Then update on the server
      final updatedTask = await apiService.updateTask(id, title, completed);
      setState(() {
        tasks[taskIndex] = updatedTask;
      });
    } catch (e) {
      print('Error editing task: $e');
      // Revert to old state if the update failed
      setState(() {
        tasks[taskIndex] = oldTask;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task')),
      );
    }
  }

  Future<void> _toggleTaskCompletion(String id, String title, bool completed) async {
    await _editTask(id, title, !completed);
  }

  Future<void> _deleteTask(String id) async {
    // Find the task index
    final taskIndex = tasks.indexWhere((task) => task['_id'] == id);
    if (taskIndex == -1) return;

    // Remove locally first
    final deletedTask = tasks[taskIndex];
    setState(() {
      tasks.removeAt(taskIndex);
    });

    try {
      await apiService.hardDeleteTask(id);
    } catch (e) {
      print('Error deleting task: $e');
      // Restore the task if deletion failed
      setState(() {
        tasks.insert(taskIndex, deletedTask);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete task')),
      );
    }
  }

  void _showAddTaskDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Task Title'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final title = controller.text.trim();
                if (title.isNotEmpty) {
                  _addTask(title);
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
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
          title: Text('Edit Task'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Task Title'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newTitle = controller.text.trim();
                if (newTitle.isNotEmpty) {
                  _editTask(id, newTitle, completed);
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
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
        title: Text('Todo List'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadTasks,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : tasks.isEmpty
              ? Center(child: Text('No tasks available'))
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ListTile(
                      title: Text(
                        task['title'],
                        style: TextStyle(
                          decoration: task['completed'] ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      leading: Checkbox(
                        value: task['completed'],
                        onChanged: (bool? value) {
                          if (value != null) {
                            _toggleTaskCompletion(task['_id'], task['title'], task['completed']);
                          }
                        },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showEditTaskDialog(
                                task['_id'],
                                task['title'],
                                task['completed'],
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTask(task['_id']),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}