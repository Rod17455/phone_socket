import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../group/group_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grupo App Chat'),
      ),
      body: Center(
        child: TextButton(
          onPressed: ()=> showDialog(
            context: context,
             builder: (BuildContext context) => AlertDialog(
              title: Text('Please enter you name'),
              content: Form(
                key: formKey,
                child: TextFormField(
                controller: nameController,
                validator: (value) {
                    if(value == null || value.length < 3) {
                      return "User must have proper name";
                    }
                    return null;
                  },
                ),
              ),
              actions: [
                TextButton(
                onPressed: () {
                  nameController.clear();
                  Navigator.pop(context);
                },
                 child: const Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red
                  ),
                  )
                ),
                TextButton(
                onPressed: () {
                  print(nameController.text);
                  if(formKey.currentState!.validate()){
                    String name = nameController.text;
                    nameController.clear();
                    Navigator.pop(context);
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => GroupPage(
                          name: name,
                          userId: uuid.v1(),
                        )
                      )
                    );
                  }
                  
                },
                 child: const Text(
                  "Enter",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.orange
                  ),
                  )
                )
              ],
             )),
          child: const Text(
            'Iniciar grupo de chat',
            style: TextStyle(
              color: Colors.teal,
              fontSize: 16
            ),
          ),
        ),
      ),
    );
  }
}