import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTachePage extends StatefulWidget {
  final String taskId;

  EditTachePage({required this.taskId});

  @override
  _EditTachePageState createState() => _EditTachePageState();
}

class _EditTachePageState extends State<EditTachePage> {
  final _firestore = FirebaseFirestore.instance;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTaskData();
  }

  Future<void> _loadTaskData() async {
    final taskDoc = await _firestore.collection('taches').doc(widget.taskId).get();
    final taskData = taskDoc.data() as Map<String, dynamic>;

    _titleController.text = taskData['title'] ?? '';
    _descriptionController.text = taskData['description'] ?? '';
  }

  Future<void> _updateTask() async {
    await _firestore.collection('taches').doc(widget.taskId).update({
      'title': _titleController.text,
      'description': _descriptionController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tâche mise à jour avec succès!')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Modifier la tâche')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateTask,
              child: Text('Mettre à jour'),
            ),
          ],
        ),
      ),
    );
  }
}
