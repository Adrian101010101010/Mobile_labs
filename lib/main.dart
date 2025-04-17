import 'package:flutter/material.dart';
import 'package:mobile_labs/page/home_page.dart';
import 'package:mobile_labs/page/login_page.dart';
import 'package:mobile_labs/page/profile_page.dart';
import 'package:mobile_labs/page/register_page.dart';
import 'package:mobile_labs/widgets/splash_screen.dart';

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
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
