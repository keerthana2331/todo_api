import 'package:flutter/material.dart';
import 'package:todo_app_provider/screens/todo_list.dart';

void main(){
  runApp( const Myapp());
}
class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home:const  todolistpage(),
    );
  }
}