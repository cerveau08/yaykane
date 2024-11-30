import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditTachePage extends StatefulWidget {
  final String taskId;

  const EditTachePage({super.key, required this.taskId});

  @override
  // ignore: library_private_types_in_public_api
  _EditTachePageState createState() => _EditTachePageState();
}

class _EditTachePageState extends State<EditTachePage> {
  final _firestore = FirebaseFirestore.instance;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));

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
    _startDate = (taskData['startDate'] as Timestamp).toDate();
    _endDate = (taskData['endDate'] as Timestamp).toDate();

    setState(() {});
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

  Future<void> _updateTask() async {
    await _firestore.collection('taches').doc(widget.taskId).update({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'startDate': Timestamp.fromDate(_startDate),
      'endDate': Timestamp.fromDate(_endDate),
    });

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tâche mise à jour avec succès!')));
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier la tâche')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 10),

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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateTask,
              child: const Text('Mettre à jour'),
            ),
          ],
        ),
      ),
    );
  }
}
