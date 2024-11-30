import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TextEditingController taskController = TextEditingController();
  final CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask() async {
    if (taskController.text.isNotEmpty) {
      await tasks.add({
        'name': taskController.text,
        'created_at': Timestamp.now(),
      });
      taskController.clear();
    }
  }

  Future<void> deleteTask(String id) async {
    await tasks.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mes Tâches')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: InputDecoration(labelText: 'Nouvelle tâche'),
                  ),
                ),
                IconButton(
                  onPressed: addTask,
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: tasks.orderBy('created_at', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text('Erreur : ${snapshot.error}');
                if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();

                final data = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final task = data[index];
                    return ListTile(
                      title: Text(task['name']),
                      trailing: IconButton(
                        onPressed: () => deleteTask(task.id),
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
