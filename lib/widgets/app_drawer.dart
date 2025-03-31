import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = const FlutterSecureStorage();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueGrey),
            child: Text('Menu',
                style: TextStyle(
                    color: Colors.white, fontSize: 24)
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () => Navigator.pushNamed(context, '/home'),
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () async {
              await storage.delete(key: 'loggedIn');
              Navigator.pushNamedAndRemoveUntil(
                  context, '/', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
