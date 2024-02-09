import 'package:cloud_firestore/cloud_firestore.dart';

class Firestoreservice {
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');

//creat task
  Future<DocumentReference<Object?>> addTask(
      String tasktile, String taskdescription, String selectedDate) {
    return tasks.add(
      {'tasktitle': tasktile, 'taskds': taskdescription, 'time': selectedDate},
    );
  }
//read task
  // Stream<QuerySnapshot> gettask() {
  //   final taskstream = tasks.orderBy('time', descending: true).snapshots();

  //   return taskstream;
  // }
//update task
  Future<void> updateTask(String docID, String tasktile, String taskdescription,
      String selectedDate) {
    return tasks.doc(docID).update({
      'tasktitle': tasktile,
      'taskds': taskdescription,
      'time': selectedDate,
    });
  }

//delete task
  Future<void> deletetask(String docid) {
    return tasks.doc(docid).delete();
  }
}
