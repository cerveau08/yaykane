import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yaykane/models/statut.dart';
import 'package:yaykane/models/taches.dart';

class AjoutTachePage extends StatefulWidget {
  @override
  _AjoutTachePageState createState() => _AjoutTachePageState();
}

class _AjoutTachePageState extends State<AjoutTachePage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 1));
  Statut _selectedStatus = Statut.enAttente; // Statut par défaut

  Future<void> createTask() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final newTask = Tache(
        id: DateTime.now().toString(), // Générer un ID unique
        title: _titleController.text,
        createdAt: DateTime.now(),
        startDate: _startDate,
        endDate: _endDate,
        isCompleted: false,
        description: _descriptionController.text,
        assignedUserId: currentUser.uid, // Assigné à l'utilisateur connecté
        statut: _selectedStatus, // Statut sélectionné
      );

      // Sauvegarder la tâche dans Firestore
      await FirebaseFirestore.instance.collection('taches').add(newTask.toMap());

      // Message de confirmation et retour à l'écran précédent
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tâche créée avec succès!')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter une tâche')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Titre de la tâche')),
            TextField(controller: _descriptionController, decoration: InputDecoration(labelText: 'Description')),

            SizedBox(height: 10),
            DropdownButton<Statut>(
              value: _selectedStatus,
              items: Statut.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status.name),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedStatus = newValue!;
                });
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: createTask,
              child: Text('Créer la tâche'),
            ),
          ],
        ),
      ),
    );
  }
}
