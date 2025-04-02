import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_labs/widgets/app_drawer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _storage = const FlutterSecureStorage();
  String _email = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String? email = await _storage.read(key: 'email');

    setState(() {
      _email = email ?? "No email found";
    });
  }

  Future<void> _editEmail() async {
    TextEditingController controller = TextEditingController(text: _email);

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Email"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "New Email"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              String newEmail = controller.text.trim();
              if (newEmail.isNotEmpty && newEmail.contains("@")) {
                await _storage.write(key: 'email', value: newEmail);
                setState(() {
                  _email = newEmail;
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueGrey,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.blueGrey),
                title: Text(
                  _email,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueGrey),
                  onPressed: _editEmail,
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
