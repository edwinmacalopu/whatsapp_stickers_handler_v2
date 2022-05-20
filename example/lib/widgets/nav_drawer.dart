import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Column(
              children: [
                Image.asset(
                  "assets/stickers/37_santa_claus/santa_claus_3.webp",
                  height: 125,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Christmas Stickers",
                  style: TextStyle(
                    color: Color.fromARGB(255, 138, 2, 2),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(
              Icons.share,
              color: Colors.black,
            ),
            title: Text(
              "Share App",
            ),
          ),
          const ListTile(
            leading: Icon(
              Icons.star_rate_rounded,
              color: Colors.black,
            ),
            title: Text(
              "Rate 5 Star",
            ),
          ),
          const ListTile(
            leading: Icon(
              Icons.list,
              color: Colors.black,
            ),
            title: Text(
              "More Apps",
            ),
          ),
        ],
      ),
    );
  }
}
