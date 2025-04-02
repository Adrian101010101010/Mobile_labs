import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SmokeDetectorPage extends StatefulWidget {
  final bool isSmokeDetected;
  final void Function(bool) onSmokeDetectedChanged;

  const SmokeDetectorPage({super.key, required this.isSmokeDetected, required this.onSmokeDetectedChanged});

  @override
  _SmokeDetectorPageState createState() => _SmokeDetectorPageState();
}

class _SmokeDetectorPageState extends State<SmokeDetectorPage> {
  late bool _isSmokeDetected;

  @override
  void initState() {
    super.initState();
    _isSmokeDetected = widget.isSmokeDetected;
  }

  void _toggleSmoke() {
    setState(() {
      _isSmokeDetected = !_isSmokeDetected;
    });
    widget.onSmokeDetectedChanged(_isSmokeDetected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smoke Detector')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isSmokeDetected ? FontAwesomeIcons.fireExtinguisher : FontAwesomeIcons.smoking,
              size: 100,
              color: _isSmokeDetected ? Colors.red : Colors.green,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleSmoke,
              child: Text(_isSmokeDetected ? 'Clear Smoke' : 'Detect Smoke'),
            ),
          ],
        ),
      ),
    );
  }
}
