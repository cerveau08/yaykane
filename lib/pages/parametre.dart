import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanelPage extends StatelessWidget {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> deleteUser(String id) async {
    await users.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Panel Administrateur')),
      body: StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Erreur : ${snapshot.error}');
          if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();

          final data = snapshot.data!.docs;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final user = data[index];
              return ListTile(
                title: Text(user['email']),
                trailing: IconButton(
                  onPressed: () => deleteUser(user.id),
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
