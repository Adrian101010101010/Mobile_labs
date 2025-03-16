import 'package:flutter/material.dart';
import '../page/login_page.dart';
import '../page/register_page.dart';
import '../page/home_page.dart';
import '../page/profile_page.dart';

void main() {
  runApp(const HomeSecurityApp());
}

class HomeSecurityApp extends StatelessWidget {
  const HomeSecurityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}