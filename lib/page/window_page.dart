import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WindowPage extends StatefulWidget {
  final bool isWindowOpen;
  final void Function(bool) onWindowStateChanged;

  const WindowPage({super.key, required this.isWindowOpen, required this.onWindowStateChanged});

  @override
  _WindowPageState createState() => _WindowPageState();
}

class _WindowPageState extends State<WindowPage> {
  late bool _isWindowOpen;

  @override
  void initState() {
    super.initState();
    _isWindowOpen = widget.isWindowOpen;
  }

  void _toggleWindow() {
    setState(() {
      _isWindowOpen = !_isWindowOpen;
    });
    widget.onWindowStateChanged(_isWindowOpen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Windows')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isWindowOpen ? FontAwesomeIcons.windowMaximize : FontAwesomeIcons.windowRestore,
              size: 100,
              color: _isWindowOpen ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleWindow,
              child: Text(_isWindowOpen ? 'Close Window' : 'Open Window'),
            ),
          ],
        ),
      ),
    );
  }
}
