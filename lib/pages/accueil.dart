import 'package:flutter/material.dart';
import 'package:yaykane/widgets/menudrawer.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _indexSelector = 0;
  String _affichage = '0 Accueil';
  void changeAffichage(int index) {
    setState(() {
      _indexSelector = index;
      switch (_indexSelector) {
        case 0:
          _affichage = '$_indexSelector Accueil';
          break;
        case 1:
          _affichage = '$_indexSelector Taches';
          break;
        case 2:
          _affichage = '$_indexSelector Historiques';
          break;
        case 3:
          _affichage = '$_indexSelector Compte';
          break;
      }
    });
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
                )),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Accueil()));
            },
          ),
        ],
      ),
      drawer: MenuDrawer(),
      body: Center(
        child: Column(
          children: [
            Text('Bienvenue sur votre application'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Taches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Historiques',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Compte',
          )
        ],
        backgroundColor: Colors.orange,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.white,
        onTap: changeAffichage,
        currentIndex: _indexSelector,
      ),
    );
  }
}
