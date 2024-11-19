import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_provider/models/save_task.dart';
import 'package:todo_app_provider/models/task_model.dart';
import 'package:todo_app_provider/pages/add_todo.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          Consumer<SaveTask>(
            builder: (context, task, child) {
              int completedTasks =
                  task.tasks.where((t) => t.isCompleted).length;
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    '$completedTasks/${task.tasks.length}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTodo()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<SaveTask>(
        builder: (context, task, child) {
          if (task.tasks.isEmpty) {
            return const Center(
              child: Text(
                'No tasks yet!\nTap + to add a new task',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: task.tasks.length,
            itemBuilder: (BuildContext context, index) {
              final currentTask = task.tasks[index];

              return Dismissible(
                key: Key(currentTask.title),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  task.removeTask(currentTask);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${currentTask.title} removed'),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          task.addTask(currentTask);
                        },
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Checkbox(
                      value: currentTask.isCompleted,
                      onChanged: (_) {
                        context.read<SaveTask>().checkTask(index);
                      },
                    ),
                    title: Text(
                      currentTask.title,
                      style: TextStyle(
                        decoration: currentTask.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: currentTask.isCompleted
                            ? Colors.blueGrey
                            : Colors.white,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddTodo(
                                  taskToEdit: currentTask,
                                  editIndex: index,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.blueGrey,
                          onPressed: () {
                            _showDeleteDialog(context, task, currentTask);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    SaveTask taskProvider,
    Task task,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: Text('Are you sure you want to delete "${task.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                taskProvider.removeTask(task);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${task.title} deleted'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        taskProvider.addTask(task);
                      },
                    ),
                  ),
                );
              },
              child: const Text(
                'DELETE',
                style: TextStyle(color: Colors.lightBlueAccent),
              ),
            ),
          ],
        );
      },
    );
  }
} 