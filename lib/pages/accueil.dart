import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yaykane/pages/admin.dart';
import 'package:yaykane/pages/taches.dart';
import 'package:yaykane/widgets/menudrawer.dart';

class Accueil extends StatefulWidget {
  final String userId;
  const Accueil({required this.userId, super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userRole;
  int _indexSelector = 0;

  Widget getBodyContent() {
    if (_userRole == null) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (_indexSelector) {
      case 0:
        return const Center(child: Text('Bienvenue sur votre application'));
      case 1:
        return const Center(child: TachePage());
      case 2:
        return const Center(child: TachePage());
      case 3:
        return AdminPage(userRole: _userRole!);
      default:
        return const Center(child: Text('Onglet inconnu'));
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    try {
      final doc = await _firestore.collection('users').doc(widget.userId).get();
      if (doc.exists) {
        setState(() {
          _userRole = doc['role'];
        });
      } else {
        setState(() {
          _userRole = 'MEMBRE';
        });
      }
    } catch (e) {
      setState(() {
        _userRole = 'MEMBRE';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(5),
              child: CircleAvatar(
                backgroundImage: const AssetImage("images/malick.jpg"),
                radius: MediaQuery.sizeOf(context).height * 0.025,
              ),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Vous êtes déjà sur la page d'accueil.")),
              );
            },
          ),
        ],
      ),
      drawer: const MenuDrawer(),
      body: getBodyContent(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Tâches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Historiques',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Compte',
          ),
        ],
        backgroundColor: Colors.orange,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.white,
        onTap: (index) {
          setState(() {
            _indexSelector = index;
          });
        },
        currentIndex: _indexSelector,
      ),
    );
  }
}
