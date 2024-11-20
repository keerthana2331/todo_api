import 'package:flutter/material.dart';
import 'package:todo_app_provider/models/task_model.dart';

class SaveTask extends ChangeNotifier {
   final List<Task> _tasks = [
    // Task(title: 'State Management', isCompleted: true),
    // Task(title: 'Provider', isCompleted: false),
    // Task(title: 'Change notifier', isCompleted: true),
    // Task(title: 'Consumer', isCompleted: false),
    // Task(title: 'Selector', isCompleted: true)
  ];

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    tasks.add(task);
    notifyListeners();
  }

  void removeTask(Task task) {
    tasks.remove(task);
    notifyListeners();
  }

  void checkTask(int index) {
    tasks[index].isDone();
    notifyListeners();
  }

  void updateTask(int index, String newTitle) {
    if (index >= 0 && index < tasks.length) {
      tasks[index] = Task(
        title: newTitle,
        isCompleted: tasks[index].isCompleted,
      );
      notifyListeners();
    }
  }

  void editTask(int index, Task updatedTask) {
    if (index >= 0 && index < tasks.length) {
      tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  int getTaskIndex(String title) {
    return tasks.indexWhere((task) => task.title == title);
  }

  void toggleTaskStatus(Task task) {}
}
