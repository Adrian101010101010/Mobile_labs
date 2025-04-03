import 'package:flutter/material.dart';
import 'package:mobile_labs/abstract_class/auth_logic_base.dart';

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
    extends AuthLogicBase<T> {
  @override
  void onLogin(String email, String password) {
    widget.onButtonPressed(email, password);
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
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText:
                    emailController.text.isNotEmpty && !isEmailValid
                        ? 'Email має закінчуватись на @gmail.com'
                        : null,
              ),
              onChanged: (value) => validateInputs(),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText:
                    passwordController.text.isNotEmpty && !isPasswordValid
                        ? 'Пароль має містити мінімум 8 символів'
                        : null,
              ),
              obscureText: true,
              onChanged: (value) => validateInputs(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (isEmailValid && isPasswordValid) ? handleLogin : null,
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
