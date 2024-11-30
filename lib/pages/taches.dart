import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:yaykane/models/statut.dart';
import 'package:yaykane/pages/ajouttache.dart';
import 'package:yaykane/pages/edittache.dart';

class TachePage extends StatefulWidget {
  const TachePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TachePageState createState() => _TachePageState();
}

class _TachePageState extends State<TachePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('taches').doc(taskId).delete();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Tâche supprimée avec succès!'),
      ));
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de la suppression : $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des tâches'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('taches').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Aucune tâche disponible.'));
          }

          final tasks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final taskData = task.data() as Map<String, dynamic>;

              // Formatage des dates
              DateTime startDate = (taskData['startDate'] as Timestamp).toDate();
              DateTime endDate = (taskData['endDate'] as Timestamp).toDate();
              String formattedStartDate = DateFormat('dd MMMM yyyy').format(startDate);
              String formattedEndDate = DateFormat('dd MMMM yyyy').format(endDate);

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(taskData['title'] ?? 'Sans titre'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (taskData['description'] != null)
                        Text(taskData['description']),
                      Text('Date de début : $formattedStartDate'),
                      Text('Date de fin : $formattedEndDate'),
                      Text('Statut : ${Statut.values[taskData['status']].name}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTachePage(taskId: task.id),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirmer la suppression'),
                              content: const Text('Voulez-vous vraiment supprimer cette tâche ?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    deleteTask(task.id);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Supprimer'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AjoutTachePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
