import 'package:flutter/material.dart';
import 'package:todo_app_provider/screens/add_page.dart';

class todolistpage extends StatefulWidget {
  const todolistpage({super.key});

  @override
  State<todolistpage> createState() => _todolistpageState();
}

class _todolistpageState extends State<todolistpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List') , 
      ),
      floatingActionButton:FloatingActionButton.extended(onPressed:(){},label:const Text('Add Todo'),) ,
    );
  }
  void navigateToAddPage(){
    final route=MaterialPageRoute(builder:(context)=> const AddTodoPage()
    );
    Navigator.push(context, route);
  }
}