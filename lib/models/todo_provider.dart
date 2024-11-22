import 'package:flutter/material.dart';
import 'package:todo_app_provider/todo_apiservice.dart';

class TodoProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _tasks = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await _apiService.fetchTasks();
    } catch (e) {
      debugPrint('Error fetching tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(String title) async {
    try {
      final newTask = await _apiService.createTask(title, false);
      _tasks.add(newTask);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding task: $e');
    }
  }

  Future<void> editTask(String id, String title, bool completed) async {
    final index = _tasks.indexWhere((task) => task['_id'] == id);
    if (index == -1) return;

    final oldTask = Map<String, dynamic>.from(_tasks[index]);
    _tasks[index] = {...oldTask, 'title': title, 'completed': completed};
    notifyListeners();

    try {
      final updatedTask = await _apiService.updateTask(id, title, completed);
      _tasks[index] = updatedTask;
    } catch (e) {
      _tasks[index] = oldTask;
      debugPrint('Error editing task: $e');
    }
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    final index = _tasks.indexWhere((task) => task['_id'] == id);
    if (index == -1) return;

    final deletedTask = _tasks[index];
    _tasks.removeAt(index);
    notifyListeners();

    try {
      await _apiService.hardDeleteTask(id);
    } catch (e) {
      _tasks.insert(index, deletedTask);
      debugPrint('Error deleting task: $e');
    }
    notifyListeners();
  }

  Future<void> toggleTaskCompletion(String id) async {
    final index = _tasks.indexWhere((task) => task['_id'] == id);
    if (index == -1) return;

    final task = _tasks[index];
    await editTask(id, task['title'], !task['completed']);
  }
}
