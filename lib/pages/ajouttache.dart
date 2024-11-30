import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yaykane/models/statut.dart';
import 'package:yaykane/models/taches.dart';

class AjoutTachePage extends StatefulWidget {
  const AjoutTachePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AjoutTachePageState createState() => _AjoutTachePageState();
}

class _AjoutTachePageState extends State<AjoutTachePage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  Statut _selectedStatus = Statut.enAttente; 

  Future<void> createTask() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final newTask = Tache(
        id: DateTime.now().toString(),
        title: _titleController.text,
        createdAt: DateTime.now(),
        startDate: _startDate,
        endDate: _endDate,
        isCompleted: false,
        description: _descriptionController.text,
        assignedUserId: currentUser.uid,
        statut: _selectedStatus,
      );

      await FirebaseFirestore.instance.collection('taches').add(newTask.toMap());

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tâche créée avec succès!')));
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ) ?? DateTime.now();

    setState(() {
      if (isStartDate) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une tâche')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Titre de la tâche')),
            TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description')),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date de début: ${_startDate.toLocal().toString().split(' ')[0]}"),
                ElevatedButton(
                  onPressed: () => _selectDate(context, true),
                  child: const Text('Choisir la date de début'),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date de fin: ${_endDate.toLocal().toString().split(' ')[0]}"),
                ElevatedButton(
                  onPressed: () => _selectDate(context, false),
                  child: const Text('Choisir la date de fin'),
                ),
              ],
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: createTask,
              child: const Text('Créer la tâche'),
            ),
          ],
        ),
      ),
    );
  }
}
