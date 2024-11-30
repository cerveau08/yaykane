import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yaykane/pages/login.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController prenomController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();

  Future<void> registerUser() async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'prenom': prenomController.text,
        'nom': nomController.text,
        'email': emailController.text,
        'adresse': adresseController.text,
        'photoUrl': userCredential.user!.photoURL ?? '',
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Compte créé avec succès!'),
      ));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()), 
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer un compte')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: prenomController, decoration: InputDecoration(labelText: 'Prénom')),
            TextField(controller: nomController, decoration: InputDecoration(labelText: 'Nom')),
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Mot de passe'), obscureText: true),
            TextField(controller: adresseController, decoration: InputDecoration(labelText: 'Adresse')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: registerUser, child: Text('S\'inscrire')),

            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text("Se connecter"),
            ),
          ],
        ),
      ),
    );
  }
}
