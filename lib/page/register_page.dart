import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_labs/widgets/auth_scaffold.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final _storage = const FlutterSecureStorage();

  Future<void> _registerUser(BuildContext context, String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email and password cannot be empty")),
      );
      return;
    }

    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'password', value: password);

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Register',
      buttonText: 'Sign Up',
      onButtonPressed: (email, password) => _registerUser(context, email, password),
      linkText: 'Already have an account? Login',
      onLinkPressed: () => Navigator.pushNamed(context, '/login'),
    );
  }
}
