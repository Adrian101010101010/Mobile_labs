import 'package:flutter/material.dart';
import '../widgets/auth_scaffold.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Login',
      subtitle: 'Welcome to our program \nHomeProMAX',
      buttonText: 'Sign In',
      onButtonPressed: () => Navigator.pushNamed(context, '/home'),
      linkText: "Don't have an account? Register",
      onLinkPressed: () => Navigator.pushNamed(context, '/register'),
    );
  }
}
