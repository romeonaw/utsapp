import 'package:utsapp/home_page.dart';
import 'package:utsapp/list_data.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: [
          const DrawerHeader(
            child: Text('Menu Aplikasi'),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Data Pekerjaan'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListData(),
                ),
              );
            },
          ),
        ]));
  }
}