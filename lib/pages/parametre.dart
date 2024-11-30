import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yaykane/models/user.dart';

class ParametrePage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Méthode pour récupérer les utilisateurs depuis Firestore
  Future<List<AppUser>> getUsers() async {
    final userSnapshot = await _firestore.collection('users').get();
    return userSnapshot.docs.map((doc) {
      return AppUser.fromMap({
        ...doc.data(),
        'uid': doc.id, // Ajoutez l'ID du document comme champ 'uid'
      });
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestion des membres')),
      body: FutureBuilder<List<AppUser>>(
        future: getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement des utilisateurs'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun utilisateur trouvé'));
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text('${user.prenom} ${user.nom}'),
                subtitle: Text(user.email),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Exemple d'action : supprimer l'utilisateur
                    _firestore.collection('users').doc(user.uid).delete();
                  },
                ),
                onTap: () {
                  // Exemple d'action : afficher les détails de l'utilisateur
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Détails de l\'utilisateur'),
                      content: Text(
                        'Nom: ${user.prenom} ${user.nom}\nEmail: ${user.email}\nAdresse: ${user.adresse}',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Fermer'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
