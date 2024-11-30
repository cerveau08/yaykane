import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yaykane/models/user.dart';

class AdminPage extends StatefulWidget {
  final String userRole;
  const AdminPage({required this.userRole, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _userRole;

  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userRole = widget.userRole;
  }

  Future<List<AppUser>> getMembres() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => AppUser.fromMap(doc.data())).toList();
  }

  Future<void> addMembre(AppUser membre) async {
    if (_userRole != 'ADMIN') {
      _showErrorDialog('Seuls les administrateurs peuvent ajouter des membres.');
      return;
    }
    await _firestore.collection('users').add(membre.toMap());
    setState(() {});
  }

  Future<void> deleteMembre(String uid) async {
    if (_userRole != 'ADMIN') {
      _showErrorDialog('Seuls les administrateurs peuvent supprimer des membres.');
      return;
    }
    await _firestore.collection('users').doc(uid).delete();
    setState(() {});
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAddMembreDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter un membre'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _prenomController, decoration: const InputDecoration(labelText: 'Prénom')),
              TextField(controller: _nomController, decoration: const InputDecoration(labelText: 'Nom')),
              TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
              TextField(controller: _adresseController, decoration: const InputDecoration(labelText: 'Adresse')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_prenomController.text.isEmpty || _nomController.text.isEmpty || _emailController.text.isEmpty || _adresseController.text.isEmpty) {
                  _showErrorDialog('Tous les champs sont obligatoires.');
                  return;
                }
                final newMembre = AppUser(
                  uid: '',
                  prenom: _prenomController.text,
                  nom: _nomController.text,
                  email: _emailController.text,
                  adresse: _adresseController.text,
                  role: 'MEMBRE',
                );
                addMembre(newMembre).then((_) {
                  _prenomController.clear();
                  _nomController.clear();
                  _emailController.clear();
                  _adresseController.clear();
                  Navigator.pop(context);
                });
              },
              child: const Text('Ajouter'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des Membres"),
        actions: [
          if (_userRole == 'ADMIN')
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _showAddMembreDialog,
            ),
        ],
      ),
      body: FutureBuilder<List<AppUser>>(
        future: getMembres(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erreur de chargement des membres'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun membre trouvé'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final membre = snapshot.data![index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: membre.photoUrl != null && membre.photoUrl!.isNotEmpty
                      ? NetworkImage(membre.photoUrl!)
                      : const AssetImage('images/default_user.png') as ImageProvider,
                ),
                title: Text('${membre.prenom} ${membre.nom}'),
                subtitle: Text(membre.email),
                trailing: _userRole == 'ADMIN'
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.delete), onPressed: () => deleteMembre(membre.uid)),
                        ],
                      )
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
