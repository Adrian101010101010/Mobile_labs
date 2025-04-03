import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthLogicBase<T extends StatefulWidget> extends State<T> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  bool isEmailValid = false;
  bool isPasswordValid = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final String? email = await storage.read(key: 'email');
    final String? password = await storage.read(key: 'password');

    if (email != null && password != null && mounted) {
      onLogin(email, password);
    }
  }

  void validateInputs() {
    setState(() {
      isEmailValid = emailController.text.endsWith('@gmail.com');
      isPasswordValid = passwordController.text.length >= 8;
    });
  }

  void handleLogin() {
    onLogin(emailController.text, passwordController.text);
    clearInputs();
  }

  void clearInputs() {
    emailController.clear();
    passwordController.clear();
    setState(() {
      isEmailValid = false;
      isPasswordValid = false;
    });
  }

  void onLogin(String email, String password);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
