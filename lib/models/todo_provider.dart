import 'package:flutter/material.dart';
import 'package:todo_app_provider/todo_apiservice.dart';

class TodoProvider with ChangeNotifier {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> tasks = [];
  bool isLoading = false;

  List<Map<String, dynamic>> get tasksss => tasks;
  bool get isLoadings => isLoading;

  Future<void> loadTasks() async {
    isLoading = true;
    notifyListeners();

    try {
      tasks = await apiService.fetchTasks();
    } catch (e) {
      debugPrint('Error fetching tasks: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(String title) async {
    try {
      final newTask = await apiService.createTask(title, false);
      tasks.add(newTask);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding task: $e');
    }
  }

  Future<void> editTask(String id, String title, bool completed) async {
    final index = tasks.indexWhere((task) => task['_id'] == id);
    if (index == -1) return;

    final oldTask = Map<String, dynamic>.from(tasks[index]);
    tasks[index] = {...oldTask, 'title': title, 'completed': completed};
    notifyListeners();

    try {
      final updatedTask = await apiService.updateTask(id, title, completed);
      tasks[index] = updatedTask;
    } catch (e) {
      tasks[index] = oldTask;
      debugPrint('Error editing task: $e');
    }
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    final index = tasks.indexWhere((task) => task['_id'] == id);
    if (index == -1) return;

    final deletedTask = tasks[index];
    tasks.removeAt(index);
    notifyListeners();

    try {
      await apiService.hardDeleteTask(id);
    } catch (e) {
      tasks.insert(index, deletedTask);
      debugPrint('Error deleting task: $e');
    }
    notifyListeners();
  }
 
  void toggleTaskCompletion(String taskId, bool isCompleted) {
    final taskIndex = tasks.indexWhere((task) => task['_id'] == taskId);
    if (taskIndex != -1) {
      tasks[taskIndex]['completed'] = isCompleted;
      notifyListeners(); 
    }
  }
}