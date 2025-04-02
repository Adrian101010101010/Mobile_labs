import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthScaffoldBase extends StatefulWidget {
  final String title;
  final String buttonText;
  final String linkText;
  final VoidCallback onLinkPressed;
  final void Function(String, String) onButtonPressed;
  final String? subtitle;

  const AuthScaffoldBase({
    required this.title,
    required this.buttonText,
    required this.onButtonPressed,
    required this.linkText,
    required this.onLinkPressed,
    super.key,
    this.subtitle,
  });

  @override
  AuthScaffoldBaseState createState();
}

abstract class AuthScaffoldBaseState<T extends AuthScaffoldBase>
    extends State<T> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final String? email = await _storage.read(key: 'email');
    final String? password = await _storage.read(key: 'password');

    if (email != null && password != null && mounted) {
      widget.onButtonPressed(email, password);
    }
  }

  void _validateInputs() {
    setState(() {
      _isEmailValid = _emailController.text.endsWith('@gmail.com');
      _isPasswordValid = _passwordController.text.length >= 8;
    });
  }

  void _handleButtonPress() {
    widget.onButtonPressed(_emailController.text, _passwordController.text);
    _clearInputs();
  }

  void _clearInputs() {
    _emailController.clear();
    _passwordController.clear();
    setState(() {
      _isEmailValid = false;
      _isPasswordValid = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.subtitle != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  widget.subtitle!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText:
                _emailController.text.isNotEmpty && !_isEmailValid
                    ? 'Email має закінчуватись на @gmail.com'
                    : null,
              ),
              onChanged: (value) => _validateInputs(),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText:
                _passwordController.text.isNotEmpty && !_isPasswordValid
                    ? 'Пароль має містити мінімум 8 символів'
                    : null,
              ),
              obscureText: true,
              onChanged: (value) => _validateInputs(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
              (_isEmailValid && _isPasswordValid)
                  ? _handleButtonPress
                  : null,
              child: Text(widget.buttonText),
            ),
            TextButton(
              onPressed: widget.onLinkPressed,
              child: Text(widget.linkText),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthScaffold extends AuthScaffoldBase {
  const AuthScaffold({
    required super.title,
    required super.buttonText,
    required super.onButtonPressed,
    required super.linkText,
    required super.onLinkPressed,
    super.key,
    super.subtitle,
  });

  @override
  AuthScaffoldBaseState<AuthScaffold> createState() => _AuthScaffoldState();
}

class _AuthScaffoldState extends AuthScaffoldBaseState<AuthScaffold> {}
