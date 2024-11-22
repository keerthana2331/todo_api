// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://crudcrud.com/api/0976b7208d7245bf97a101a69752c9b9";

  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/tasks'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load tasks');
    }
  }

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

  Future<Map<String, dynamic>> updateTask(String id, String title, bool completed) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/tasks/$id'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": title,
          "completed": completed,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // If the API doesn't return the updated object, create it manually
        return {
          "_id": id,
          "title": title,
          "completed": completed,
        };
      } else {
        print('Update failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to update task');
      }
    } catch (e) {
      print('Error in updateTask: $e');
      throw Exception('Failed to update task: $e');
    }
  }

  Future<void> hardDeleteTask(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/tasks/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete task');
    }
  }
}