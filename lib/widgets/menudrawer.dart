import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  Future<void> ouvrirLien(String url) async {
    final Uri lien = Uri.parse(url);
    if (!await launchUrl(lien)) {
      throw Exception('Could not launch $lien');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.009,
          ),
          CircleAvatar(
            backgroundImage: const AssetImage(
              'images/malick.jpg',
            ),
            radius: MediaQuery.sizeOf(context).height * 0.14,
            child: GestureDetector(
              onTap: () {
                ouvrirLien("https://www.facebook.com/malick.coly.cerv");
              },
            ),
          ),
          const Divider(),
          const ListTile(
              leading: Icon(Icons.person, color: Colors.black),
              title: Text("Malick COLY"),
              visualDensity: VisualDensity(horizontal: -4)),
          const ListTile(
              leading: Icon(Icons.phone, color: Colors.black),
              title: Text("78 405 93 30"),
              visualDensity: VisualDensity(horizontal: -4)),
          const ListTile(
              leading: Icon(Icons.email, color: Colors.black),
              title: Text("malickcoly342@gmail.com"),
              visualDensity: VisualDensity(horizontal: -4)),
          const ListTile(
              leading: Icon(Icons.map, color: Colors.black),
              title: Text("Parcelles Assainies, Unité 19, Villa 107"),
              visualDensity: VisualDensity(horizontal: -4)),
          const Divider(),
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.sizeOf(context).height * 0.015),
            child: Text(
              "Suivez-moi",
              style: TextStyle(
                  fontSize: MediaQuery.sizeOf(context).height * 0.025,
                  color: Colors.black),
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.0125,
          ),
          Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: const AssetImage(
                    'images/linkedin.png',
                  ),
                  radius: MediaQuery.sizeOf(context).height * 0.027,
                  child: GestureDetector(
                    onTap: () {
                      ouvrirLien("https://www.linkedin.com/in/malickcolycerv/");
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).height * 0.020,
                ),
                CircleAvatar(
                  backgroundImage: const AssetImage(
                    'images/facebook.png',
                  ),
                  radius: MediaQuery.sizeOf(context).height * 0.027,
                  child: GestureDetector(
                    onTap: () {
                      ouvrirLien("https://www.facebook.com/malick.coly.cerv");
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).height * 0.020,
                ),
                CircleAvatar(
                  backgroundImage: const AssetImage(
                    'images/x.webp',
                  ),
                  radius: MediaQuery.sizeOf(context).height * 0.027,
                  child: GestureDetector(
                    onTap: () {
                      ouvrirLien("https://x.com/CervColy");
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).height * 0.020,
                ),
                CircleAvatar(
                  backgroundImage: const AssetImage(
                    'images/github.png',
                  ),
                  radius: MediaQuery.sizeOf(context).height * 0.027,
                  child: GestureDetector(
                    onTap: () {
                      ouvrirLien("https://github.com/cerveau08");
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).height * 0.020,
                ),
              ]),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.0125,
          ),
        ],
      ),
    );
  }
}
