import 'package:flutter/material.dart';

class AuthScaffold extends StatelessWidget {
  final String title, buttonText, linkText;
  final String? subtitle;
  final VoidCallback onButtonPressed, onLinkPressed;

  const AuthScaffold({
    required this.title,
    this.subtitle,
    required this.buttonText,
    required this.onButtonPressed,
    required this.linkText,
    required this.onLinkPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  subtitle!,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            TextField(decoration: const InputDecoration(labelText: 'Email')),
            TextField(decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: onButtonPressed, child: Text(buttonText)),
            TextButton(onPressed: onLinkPressed, child: Text(linkText)),
          ],
        ),
      ),
    );
  }
}
