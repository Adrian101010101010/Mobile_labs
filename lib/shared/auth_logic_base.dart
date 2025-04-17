import 'package:flutter/material.dart';
import 'package:mobile_labs/services/auth_storage.dart';

abstract class AuthLogicBase<T extends StatefulWidget> extends State<T> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthStorage authStorage = AuthStorage();

  bool isEmailValid = false;
  bool isPasswordValid = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await authStorage.loadCredentials();
    if (authStorage.email != null && authStorage.password != null && mounted) {
      onLogin(authStorage.email!, authStorage.password!);
    }
  }

  void validateInputs() {
    setState(() {
      isEmailValid = emailController.text.endsWith('@gmail.com');
      isPasswordValid = passwordController.text.length >= 8;
    });
  }

  void handleLogin() {
    authStorage.saveCredentials(emailController.text, passwordController.text);
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
