import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TodoProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do App',
      home: TodoScreen(),
    );
  }
}

class TodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => todoProvider.fetchTodos(),
          ),
        ],
      ),
      body: FutureBuilder(
        future: todoProvider.fetchTodos(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: todoProvider.todos.length,
            itemBuilder: (ctx, index) {
              final todo = todoProvider.todos[index];
              return ListTile(
                title: Text(todo.title),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        final controller =
                            TextEditingController(text: todo.title);
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Edit To-Do'),
                            content: TextField(
                              controller: controller,
                              decoration:
                                  const InputDecoration(labelText: 'Title'),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  todoProvider.updateTodo(
                                      todo.id, controller.text);
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text('Update'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => todoProvider.deleteTodo(todo.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final controller = TextEditingController();
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Add To-Do'),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    todoProvider.addTodo(controller.text);
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
