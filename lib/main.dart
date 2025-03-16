import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ColorChangingScreen(),
    );
  }
}

class ColorChangingScreen extends StatefulWidget {
  const ColorChangingScreen({super.key});

  @override
  State<ColorChangingScreen> createState() => _ColorChangingScreenState();
}

class _ColorChangingScreenState extends State<ColorChangingScreen> {
  Color _backgroundColor = Colors.white;
  final TextEditingController _controller = TextEditingController();

  void _changeColor(String text) {
    final Map<String, Color> colorMap = {
      'red': Colors.red,
      'green': Colors.green,
      'blue': Colors.blue,
      'yellow': Colors.yellow,
      'black': Colors.black,
      'white': Colors.white,
      'purple': Colors.purple,
      'orange': Colors.orange,
    };

    if (colorMap.containsKey(text.toLowerCase())) {
      setState(() {
        _backgroundColor = colorMap[text.toLowerCase()]!;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This color does not exist.!'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      color: _backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter color name',
              ),
              onSubmitted: _changeColor,
            ),
          ),
        ),
      ),);
  }
}
