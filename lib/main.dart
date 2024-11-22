// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_provider/models/todo_provider.dart';
import 'package:todo_app_provider/pages/add_todo.dart';
import 'package:todo_app_provider/pages/todo_list.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.tealAccent,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF1F1F1F),
          elevation: 6,
          shadowColor: Colors.black45,
          titleTextStyle: TextStyle(
            color: Colors.tealAccent,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
          iconTheme: IconThemeData(color: Colors.tealAccent),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
          elevation: 6,
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          shadowColor: Colors.black87,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF292929),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:  const BorderSide(color: Colors.tealAccent, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:  const BorderSide(color: Colors.tealAccent, width: 1.5),
          ),
          hintStyle: const TextStyle(color: Colors.white38, fontStyle: FontStyle.italic),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.tealAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.tealAccent,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          labelLarge: TextStyle(
            color: Colors.tealAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => TodoList(),
        '/add-todo-screen': (_) => const AddTodo(),
      },
    );
  }
}
