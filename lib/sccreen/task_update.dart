import 'package:flutter/material.dart';
import 'package:task_manager_flutter/service/firestore.dart';

class taskupdate extends StatefulWidget {
  final String taskid;
  final String tasktitle;
  final String taskdescription;
  final String time;

  taskupdate({
    super.key,
    required this.taskid,
    required this.tasktitle,
    required this.taskdescription,
    required this.time,
  });

  @override
  State<taskupdate> createState() => _taskupdateState();
}

class _taskupdateState extends State<taskupdate> {
  final Firestoreservice firestoreservice = Firestoreservice();

  late String taskid;
  late TextEditingController tasktitle;
  late TextEditingController taskdescription;
  late DateTime selectedDate;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    taskid = widget.taskid;
    tasktitle = TextEditingController(text: widget.tasktitle);
    taskdescription = TextEditingController(text: widget.taskdescription);
    selectedDate =
        DateTime.parse(widget.time); // Initialize selected date to current date
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
        title: Text("Task update"),
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
                .updateTask(
                  widget.taskid,
                  tasktitle.text,
                  taskdescription.text,
                  selectedDate.toString(),
                )
                .then((value) => Navigator.pop(context))
                .catchError(
                    (error) => print("Fail to update task due to $error"));
          }
        },
        child: const Icon(Icons.update),
      ),
    );
  }
}
