import 'package:flutter/material.dart';
import 'package:mobile_labs/widgets/auth_scaffold.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Register',
      buttonText: 'Sign Up',
      onButtonPressed: () => Navigator.pushNamed(context, '/home'),
      linkText: 'Already have an account? Login',
      onLinkPressed: () => Navigator.pushNamed(context, '/'),
    );
  }
}
