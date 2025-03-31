import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthScaffold extends StatefulWidget {
  final String title, buttonText, linkText;
  final String? subtitle;
  final VoidCallback onButtonPressed, onLinkPressed;

  const AuthScaffold({
    required this.title,
    required this.buttonText,
    required this.onButtonPressed,
    required this.linkText,
    required this.onLinkPressed,
    this.subtitle,
    super.key,
  });

  @override
  _AuthScaffoldState createState() => _AuthScaffoldState();
}

class _AuthScaffoldState extends State<AuthScaffold> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? isLoggedIn = await _storage.read(key: 'loggedIn');
    if (isLoggedIn == 'true') {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  Future<void> _saveCredentials() async {
    if (_emailController.text == '1111' && _passwordController.text == '8888') {
      await _storage.write(key: 'loggedIn', value: 'true');
      widget.onButtonPressed();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password!')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
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
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            TextField(
              controller: _emailController,
              focusNode: _emailFocus,
              decoration: const InputDecoration(labelText: 'Email'),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocus),
            ),
            TextField(
              controller: _passwordController,
              focusNode: _passwordFocus,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) async => await _saveCredentials(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveCredentials,
              child: Text(widget.buttonText),
            ),
            TextButton(onPressed: widget.onLinkPressed, child: Text(widget.linkText)),
          ],
        ),
      ),
    );
  }
}
