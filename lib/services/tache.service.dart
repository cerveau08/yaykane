import 'package:cloud_firestore/cloud_firestore.dart';

class TaskService {
  final CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(String name) async {
    await tasks.add({
      'name': name,
      'created_at': Timestamp.now(),
    });
  }

  Future<void> deleteTask(String id) async {
    await tasks.doc(id).delete();
  }

  Stream<QuerySnapshot> getTasks() {
    return tasks.orderBy('created_at', descending: true).snapshots();
  }
}
