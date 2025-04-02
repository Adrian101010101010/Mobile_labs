import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MovementPage extends StatefulWidget {
  const MovementPage({
    required this.isMovementDetected,
    required this.onMovementDetectedChanged,
    super.key,
  });

  final bool isMovementDetected;
  final void Function(bool) onMovementDetectedChanged;

  @override
  State<MovementPage> createState() => _MovementPageState();
}

class _MovementPageState extends State<MovementPage> {
  late bool _isMovementDetected;

  @override
  void initState() {
    super.initState();
    _isMovementDetected = widget.isMovementDetected;
  }

  void _toggleMovement() {
    setState(() {
      _isMovementDetected = !_isMovementDetected;
    });
    widget.onMovementDetectedChanged(_isMovementDetected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movement in Corridor')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isMovementDetected
                  ? FontAwesomeIcons.personWalking
                  : FontAwesomeIcons.circleXmark,
              size: 100,
              color: _isMovementDetected ? Colors.red : Colors.green,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleMovement,
              child: Text(
                _isMovementDetected ? 'Stop Movement' : 'Detect Movement',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
