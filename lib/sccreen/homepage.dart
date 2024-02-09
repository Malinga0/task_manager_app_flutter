import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_flutter/service/firestore.dart';
import 'package:task_manager_flutter/sccreen/task_create.dart';
import 'package:task_manager_flutter/sccreen/task_update.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Firestoreservice firestoreservice = Firestoreservice();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      appBar: AppBar(
        title: Text(
          'Task Manager',
        ),
        elevation: 0,
      ),
      //button for create new task
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskBox(),
            ),
          );
        },
        label: Text("Add task"),
        icon: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic>? data =
                  document.data() as Map<String, dynamic>?;
              // print('Data from Firestore: $data');
              // print('doc id: ${document.id}');
              // print(data);
              if (data == null ||//check is that null data
                  !data.containsKey('tasktitle') ||
                  !data.containsKey('taskds') ||
                  !data.containsKey('time')) {
                return ListTile(
                  title: Text('Missing data'),
                );
              }

              String taskTitle = data['tasktitle'] ?? 'Unknown';
              String taskDescription = data['taskds'] ?? 'No description';
              String time = data['time'] ?? 'No due date';
              String docID = document.id;
              // print(docID);
              // print(taskTitle);

              //show card
              return Card(
                elevation: 2,
                margin: EdgeInsets.all(10),
                color: Color.fromARGB(255, 167, 122, 245),
                child: ListTile(
                  title: Text(taskTitle),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(taskDescription),
                      Text('Due date: $time'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //update button
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => taskupdate(
                                taskid: docID,
                                tasktitle: taskTitle,
                                taskdescription: taskDescription,
                                time: time,
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.edit),
                      ),
                      //delete button
                      IconButton(
                        onPressed: () {
                          firestoreservice.deletetask(docID);
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
