import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DoorPage extends StatefulWidget {
  final bool isDoorOpen;
  final void Function(bool) onDoorStateChanged;

  const DoorPage({
    super.key,
    required this.isDoorOpen,
    required this.onDoorStateChanged,
  });

  @override
  _DoorPageState createState() => _DoorPageState();
}

class _DoorPageState extends State<DoorPage> {
  late bool _isDoorOpen;

  @override
  void initState() {
    super.initState();
    _isDoorOpen = widget.isDoorOpen;
  }

  void _toggleDoor() {
    setState(() {
      _isDoorOpen = !_isDoorOpen;
    });
    widget.onDoorStateChanged(_isDoorOpen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrance Door')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isDoorOpen
                  ? FontAwesomeIcons.doorOpen
                  : FontAwesomeIcons.doorClosed,
              size: 100,
              color: _isDoorOpen ? Colors.red : Colors.green,
            ),
            const SizedBox(height: 20),
            Text(
              _isDoorOpen ? 'Door is OPEN' : 'Door is CLOSED',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _isDoorOpen ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleDoor,
              child: Text(_isDoorOpen ? 'Close Door' : 'Open Door'),
            ),
          ],
        ),
      ),
    );
  }
}
