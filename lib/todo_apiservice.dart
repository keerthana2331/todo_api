import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://crudcrud.com/api/b5010763945c4e8c9780632ac62f3412";

  // Fetch all tasks
  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/tasks'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  // Create a new task
  Future<Map<String, dynamic>> createTask(String title, bool completed) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "completed": completed,
      }),
    );
    
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create task');
    }
  }

  // Update an existing task
  Future<Map<String, dynamic>> updateTask(String id, String title, bool completed) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "completed": completed,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update task');
    }
  }

  // Soft delete - marks task as deleted without removing it
  Future<Map<String, dynamic>> softDeleteTask(String id) async {
    return await updateTask(id, "", true);
  }

  // Archive task - moves it to archived state
  Future<Map<String, dynamic>> archiveTask(String id, String title) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "completed": true,
        "archived": true,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to archive task');
    }
  }

  // Hard delete - completely removes the task
  Future<void> hardDeleteTask(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/tasks/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}