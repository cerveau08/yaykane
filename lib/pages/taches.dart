import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yaykane/models/statut.dart';
import 'package:yaykane/pages/ajout-tache.dart';
import 'package:yaykane/pages/edit-tache.dart';

class TachePage extends StatefulWidget {
  @override
  _TachePageState createState() => _TachePageState();
}

class _TachePageState extends State<TachePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fonction pour supprimer une tâche
  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('taches').doc(taskId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Tâche supprimée avec succès!'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de la suppression : $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des tâches'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('taches').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucune tâche disponible.'));
          }

          final tasks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final taskData = task.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(taskData['title'] ?? 'Sans titre'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (taskData['description'] != null)
                        Text(taskData['description']),
                      Text('Date de début : ${taskData['startDate']}'),
                      Text('Date de fin : ${taskData['endDate']}'),
                      Text('Statut : ${Statut.values[taskData['status']].name}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bouton Modifier
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTachePage(taskId: task.id),
                            ),
                          );
                        },
                      ),
                      // Bouton Supprimer
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirmer la suppression'),
                              content: Text('Voulez-vous vraiment supprimer cette tâche ?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    deleteTask(task.id);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Supprimer'),
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
        child: Icon(Icons.add),
      ),
    );
  }
}
