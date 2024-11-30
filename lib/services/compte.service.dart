import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> getUsers() {
    return users.snapshots();
  }

  Future<void> deleteUser(String id) async {
    await users.doc(id).delete();
  }
}
