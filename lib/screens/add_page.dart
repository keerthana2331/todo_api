import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController =TextEditingController();
  TextEditingController descriptionController =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title:  const Text('Add Todo'),
      ),
      body: ListView(
        padding:  const EdgeInsets.all(20),
        children:[
          TextField(
            controller: titleController,
            decoration:const InputDecoration(hintText: 'Title') ,
          ),
          const TextField(
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {}, 
            child: const Text('Submit')),
       
        ],
      ),
    );
    
  }
  void SubmitData(){
    final title=titleController.text;
    final description=descriptionController.text;
    final body={
      "title":title,
      "description":description,
      "is_completed":false,
      
    };
    final url=''
  }
}