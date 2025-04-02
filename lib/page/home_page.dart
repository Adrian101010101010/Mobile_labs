import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_labs/widgets/app_drawer.dart';
import 'package:mobile_labs/page/movement_page.dart';
import 'package:mobile_labs/page/cameras_page.dart';
import 'package:mobile_labs/page/smoke_detector_page.dart';
import 'package:mobile_labs/page/window_page.dart';
import 'package:mobile_labs/page/door_page.dart';
import 'package:mobile_labs/page/signal_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isProtected = false;
  List<String> _eventLog = [];

  bool _isDoorOpen = false;
  bool _isWindowOpen = false;
  bool _isSmokeDetected = false;
  bool _isMovementDetected = false;

  void _toggleProtection() {
    showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Security Control"),
            content: Text(
              _isProtected
                  ? "Disable security system?"
                  : "Enable security system?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isProtected = !_isProtected;
                    _eventLog.add(
                      "${DateTime.now()} - ${_isProtected ? 'Enabled' : 'Disabled'}",
                    );
                  });
                  Navigator.pop(context);
                },
                child: Text(_isProtected ? "Disable" : "Enable"),
              ),
            ],
          ),
    );
  }

  void _openCamerasPage() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (context) => const CamerasPage()),
    );
  }

  void _openSignalPage() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (context) => SignalPage(eventLog: _eventLog)),
    );
  }

  void _openDoorPage() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder:
            (context) => DoorPage(
              isDoorOpen: _isDoorOpen,
              onDoorStateChanged: _onDoorStateChanged,
            ),
      ),
    );
  }

  void _openWindowPage() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder:
            (context) => WindowPage(
              isWindowOpen: _isWindowOpen,
              onWindowStateChanged: _onWindowStateChanged,
            ),
      ),
    );
  }

  void _openSmokeDetectorPage() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder:
            (context) => SmokeDetectorPage(
              isSmokeDetected: _isSmokeDetected,
              onSmokeDetectedChanged: _onSmokeDetectedChanged,
            ),
      ),
    );
  }

  void _openMovementPage() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder:
            (context) => MovementPage(
              isMovementDetected: _isMovementDetected,
              onMovementDetectedChanged: _onMovementDetectedChanged,
            ),
      ),
    );
  }

  void _onDoorStateChanged(bool isOpen) {
    setState(() {
      _isDoorOpen = isOpen;
    });
    if (_isProtected && isOpen) {
      _eventLog.add("${DateTime.now()} - Door opened (Security breach!)");
    }
  }

  void _onWindowStateChanged(bool isOpen) {
    setState(() {
      _isWindowOpen = isOpen;
    });
    if (_isProtected && isOpen) {
      _eventLog.add("${DateTime.now()} - Window opened (Security breach!)");
    }
  }

  void _onSmokeDetectedChanged(bool isDetected) {
    setState(() {
      _isSmokeDetected = isDetected;
    });
    if (_isProtected && isDetected) {
      _eventLog.add("${DateTime.now()} - Smoke detected (Security breach!)");
    }
  }

  void _onMovementDetectedChanged(bool isDetected) {
    setState(() {
      _isMovementDetected = isDetected;
    });
    if (_isProtected && isDetected) {
      _eventLog.add("${DateTime.now()} - Movement detected (Security breach!)");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Security')),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      _isProtected ? Icons.lock : Icons.lock_open,
                      size: 50,
                      color: _isProtected ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _isProtected
                          ? 'The house is protected.'
                          : 'The house is unprotected.',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _controlButton(Icons.lock, 'Protection', _toggleProtection),
                _controlButton(Icons.videocam, 'Cameras', _openCamerasPage),
                _controlButton(Icons.notifications, 'Signal', _openSignalPage),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _sensorTile(
                    FontAwesomeIcons.doorClosed,
                    'Entrance door',
                    _isDoorOpen,
                    _openDoorPage,
                  ),
                  _sensorTile(
                    FontAwesomeIcons.windowRestore,
                    'Windows',
                    _isWindowOpen,
                    _openWindowPage,
                  ),
                  _sensorTile(
                    FontAwesomeIcons.fireExtinguisher,
                    'Smoke detector',
                    _isSmokeDetected,
                    _openSmokeDetectorPage,
                  ),
                  _sensorTile(
                    FontAwesomeIcons.personRunning,
                    'Movement in the corridor',
                    _isMovementDetected,
                    _openMovementPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _controlButton(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: Colors.blueGrey,
          child: Icon(icon, size: 28),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _sensorTile(
    IconData icon,
    String title,
    bool isActive,
    VoidCallback onPressed,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, size: 28, color: Colors.blueGrey),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          isActive ? 'Opened' : 'Closed',
          style: TextStyle(color: isActive ? Colors.red : Colors.green),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onPressed,
      ),
    );
  }
}
