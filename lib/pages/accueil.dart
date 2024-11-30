import 'package:flutter/material.dart';
import 'package:yaykane/pages/taches.dart';
import 'package:yaykane/widgets/menudrawer.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _indexSelector = 0;

  // Méthode pour afficher différents widgets selon l'onglet sélectionné
  Widget getBodyContent() {
    switch (_indexSelector) {
      case 0:
        return Center(child: Text('Bienvenue sur votre application'));
      case 1:
        return Center(child: TachePage());
      case 2:
        return Center(child: TachePage());
      case 3:
        return Center(child: Text('Informations sur le compte'));
      default:
        return Center(child: Text('Onglet inconnu'));
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Accueil()),
              );
            },
          ),
        ],
      ),
      drawer: MenuDrawer(),
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
