import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_labs/widgets/auth_scaffold.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> _loginUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    if (email.isEmpty || password.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    final String? savedEmail = await _storage.read(key: 'email');
    final String? savedPassword = await _storage.read(key: 'password');

    if (email == savedEmail && password == savedPassword) {
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Login',
      buttonText: 'Sign In',
      onButtonPressed: (email, password) {
        _loginUser(context, email, password);
      },
      linkText: "Don't have an account? Register",
      onLinkPressed: () => Navigator.pushNamed(context, '/register'),
    );
  }
}
