import 'package:flutter/material.dart';
import 'package:task_manager_flutter/firestore.dart';

class TaskBox extends StatefulWidget {
  const TaskBox({
    Key? key,
  });

  @override
  State<TaskBox> createState() => _TaskBoxState();
}

class _TaskBoxState extends State<TaskBox> {
  final Firestoreservice firestoreservice = Firestoreservice();

  final TextEditingController tasktitle = TextEditingController();
  final TextEditingController taskdescription = TextEditingController();
  late DateTime selectedDate;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate =
            DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 170, 130, 240),
      appBar: AppBar(
        title: Text("Task"),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: tasktitle,
                decoration: InputDecoration(
                  labelText: "Task Title",
                  hintText: "Enter task title",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: taskdescription,
                decoration: InputDecoration(
                  labelText: "Task Description",
                  hintText: "Enter task description",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Due Date: ${selectedDate.toString().substring(0, 10)}',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _selectDate(context),
                    icon: Icon(Icons.calendar_today),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            firestoreservice
                .addTask(
                  tasktitle.text,
                  taskdescription.text,
                  selectedDate.toString(),
                )
                .then((value) => Navigator.pop(context))
                .catchError(
                    (error) => print("Fail to add new task due to $error"));
          } else {}
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
