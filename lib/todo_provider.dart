import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'todo.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];
  final String baseUrl =
      'https://crudcrud.com/api/cfadcc837b7d4956b5bc8bb1787f9300/todos';

  List<Todo> get todos => _todos;

  Future<void> fetchTodos() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _todos = data.map((json) {
          return Todo(
            id: json['_id'],
            title: json['title'],
            isCompleted: json['isCompleted'],
          );
        }).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to fetch todos');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addTodo(String title) async {
    final newTodo = Todo(
      id: DateTime.now().toString(),
      title: title,
    );

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': newTodo.title,
          'isCompleted': newTodo.isCompleted,
        }),
      );

      if (response.statusCode == 201) {
        final id = json.decode(response.body)['_id'];
        _todos.add(Todo(
            id: id, title: newTodo.title, isCompleted: newTodo.isCompleted));
        notifyListeners();
      } else {
        throw Exception('Failed to add todo');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateTodo(String id, String newTitle) async {
    final todoIndex = _todos.indexWhere((todo) => todo.id == id);
    if (todoIndex == -1) return;

    try {
      final url = '$baseUrl/$id';
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': newTitle,
          'isCompleted': _todos[todoIndex].isCompleted,
        }),
      );

      if (response.statusCode == 200) {
        _todos[todoIndex].title = newTitle;
        notifyListeners();
      } else {
        throw Exception('Failed to update todo');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteTodo(String id) async {
    final todoIndex = _todos.indexWhere((todo) => todo.id == id);
    if (todoIndex == -1) return;

    try {
      final url = '$baseUrl/$id';
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        _todos.removeAt(todoIndex);
        notifyListeners();
      } else {
        throw Exception('Failed to delete todo');
      }
    } catch (error) {
      rethrow;
    }
  }
}
