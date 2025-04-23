import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mobile_labs/services/auth_storage.dart';

abstract class AuthLogicBase<T extends StatefulWidget> extends State<T> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthStorage authStorage = AuthStorage();

  bool isEmailValid = false;
  bool isPasswordValid = false;

  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      result,
    ) {
      final hasConnection = result != ConnectivityResult.none;

      if (!hasConnection) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Connection lost. You are offline.'),
                backgroundColor: Colors.red,
              ),
            );
          });
        }
      } else {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Connection restored.'),
                backgroundColor: Colors.green,
              ),
            );
          });
        }
      }
    });
  }

  Future<void> _checkLoginStatus() async {
    await authStorage.loadCredentials();

    final isLoggedIn = await authStorage.isLoggedIn();
    final connectivityResult = await Connectivity().checkConnectivity();
    final hasConnection = connectivityResult != ConnectivityResult.none;

    if (isLoggedIn &&
        authStorage.email != null &&
        authStorage.password != null &&
        mounted) {
      if (!hasConnection) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'You are offline. Some features may be unavailable.',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        });
      }

      onLogin(authStorage.email!, authStorage.password!);
    }
  }

  void validateInputs() {
    setState(() {
      isEmailValid = emailController.text.endsWith('@gmail.com');
      isPasswordValid = passwordController.text.length >= 8;
    });
  }

  void handleLogin() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final hasConnection = connectivityResult != ConnectivityResult.none;

    if (!hasConnection) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No internet connection'),
              backgroundColor: Colors.red,
            ),
          );
        });
      }
      return;
    }

    await authStorage.saveCredentials(
      emailController.text,
      passwordController.text,
    );
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
    _connectivitySubscription?.cancel();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
