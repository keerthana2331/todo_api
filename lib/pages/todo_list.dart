import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_provider/models/todo_provider.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  void showAddTaskDialog(BuildContext context) {
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
                  context.read<TodoProvider>().addTask(title);
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

  void showEditTaskDialog(
      BuildContext context, String id, String currentTitle, bool completed) {
    final TextEditingController controller =
        TextEditingController(text: currentTitle);
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
                  context
                      .read<TodoProvider>()
                      .editTask(id, newTitle, completed);
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
            onPressed: () => context.read<TodoProvider>().loadTasks(),
          ),
        ],
      ),
      body: Selector<TodoProvider, List<Map<String, dynamic>>>(
        selector: (context, todoProvider) => todoProvider.tasks,
        builder: (context, tasks, child) {
          if (context.watch<TodoProvider>().isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks available'));
          }
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                child: ListTile(
                  leading: Selector<TodoProvider, bool>(
                    selector: (context, todoProvider) =>
                        todoProvider.tasks[index]['completed'],
                    builder: (context, completed, child) {
                      return Checkbox(
                        value: completed,
                        onChanged: (bool? value) {
                          context.read<TodoProvider>().editTask(
                              task['_id'], task['title'], value ?? false);
                        },
                      );
                    },
                  ),
                  title: Selector<TodoProvider, String>(
                    selector: (context, todoProvider) =>
                        todoProvider.tasks[index]['title'],
                    builder: (context, title, child) {
                      return Text(
                        title,
                        style: TextStyle(
                          decoration: task['completed']
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      );
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => showEditTaskDialog(
                          context,
                          task['_id'],
                          task['title'],
                          task['completed'],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => context
                            .read<TodoProvider>()
                            .deleteTask(task['_id']),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
