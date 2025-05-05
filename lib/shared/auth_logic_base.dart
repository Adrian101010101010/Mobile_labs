import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_labs/services/auth_storage.dart';
import 'package:mobile_labs/services/connectivity_notifier.dart';

abstract class AuthLogicBase<T extends StatefulWidget> extends State<T> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthStorage authStorage = AuthStorage();

  bool isEmailValid = false;
  bool isPasswordValid = false;

  late final ConnectivityNotifier _connectivityNotifier;
  StreamSubscription<bool>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    _connectivityNotifier = ConnectivityNotifier();

    _connectivitySubscription =
        _connectivityNotifier.onStatusChange.listen((isConnected) {
          if (!mounted) return;

          final message = isConnected
              ? 'Connection restored.'
              : 'Connection lost. You are offline.';
          final color = isConnected ? Colors.green : Colors.red;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: color,
              ),
            );
          });
        });

    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await authStorage.loadCredentials();

    final isLoggedIn = await authStorage.isLoggedIn();
    final hasConnection = await _connectivityNotifier.getInitialStatus();

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
    final hasConnection = await _connectivityNotifier.getInitialStatus();

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
    _connectivityNotifier.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
