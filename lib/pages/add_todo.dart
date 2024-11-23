// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_provider/models/todo_provider.dart';

import 'package:todo_app_provider/models/task_model.dart';

class AddTodo extends StatelessWidget {
  final Task? taskToEdit;

  const AddTodo({Key? key, this.taskToEdit}) : super(key: key);

  void saveTask(BuildContext context, String title, bool isCompleted) {
    if (title.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final todoProvider = context.read<TodoProvider>();

    if (taskToEdit != null) {
      todoProvider.editTask(
        taskToEdit!.id!,
        title.trim(),
        isCompleted,
      );
    } else {
      todoProvider.addTask(
        title.trim(),
      );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: taskToEdit?.title ?? '',
    );
    bool isCompleted = taskToEdit?.isCompleted ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          taskToEdit != null ? 'Edit Todo' : 'Add Todo',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller,
              autofocus: taskToEdit == null,
              decoration: InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Colors.tealAccent, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.teal, width: 2),
                ),
                prefixIcon: const Icon(
                  Icons.task_alt,
                  color: Colors.tealAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            StatefulBuilder(
              builder: (context, setState) => CheckboxListTile(
                title: const Text('Mark as completed'),
                activeColor: Colors.tealAccent,
                value: isCompleted,
                onChanged: (value) {
                  setState(() {
                    isCompleted = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => saveTask(
                context,
                controller.text,
                isCompleted,
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: Text(
                taskToEdit != null ? 'Update Task' : 'Add Task',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
