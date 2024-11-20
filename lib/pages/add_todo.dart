import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_provider/models/save_task.dart';
import 'package:todo_app_provider/models/task_model.dart';

class AddTodo extends StatefulWidget {
  final Task? taskToEdit;
  final int? editIndex;

  const AddTodo({
    super.key,
    this.taskToEdit,
    this.editIndex,
  });

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  late final TextEditingController controller;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.taskToEdit?.title ?? '');
    isCompleted = widget.taskToEdit?.isCompleted ?? false;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void saveTask(BuildContext context) {
    if (controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final taskProvider = context.read<SaveTask>();

    if (widget.taskToEdit != null && widget.editIndex != null) {
      taskProvider.editTask(
        widget.editIndex!,
        Task(
          title: controller.text.trim(),
          isCompleted: isCompleted,
        ),
      );
    } else {
      taskProvider.addTask(
        Task(
          title: controller.text.trim(),
          isCompleted: isCompleted,
        ),
      );
    }

    controller.clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.taskToEdit != null ? 'Edit Todo' : 'Add Todo',
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
              autofocus: widget.taskToEdit == null,
              decoration: InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:const BorderSide(color: Colors.tealAccent, width: 2),
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
            CheckboxListTile(
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => saveTask(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                iconColor: Colors.teal,
                disabledIconColor: Colors.white,
                elevation: 5,
              ),
              child: Text(
                widget.taskToEdit != null ? 'Update Task' : 'Add Task',
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
