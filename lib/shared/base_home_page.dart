import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_labs/page/cameras_page.dart';
import 'package:mobile_labs/page/door_page.dart';
import 'package:mobile_labs/page/movement_page.dart';
import 'package:mobile_labs/page/signal_page.dart';
import 'package:mobile_labs/page/smoke_detector_page.dart';
import 'package:mobile_labs/page/window_page.dart';
import 'package:mobile_labs/widgets/app_drawer.dart';

abstract class BaseHomePage extends StatefulWidget {
  const BaseHomePage({super.key});

  @override
  BaseHomePageState createState();
}

abstract class BaseHomePageState<T extends BaseHomePage> extends State<T> {
  bool isProtected = false;
  final List<String> eventLog = [];

  bool isDoorOpen = false;
  bool isWindowOpen = false;
  bool isSmokeDetected = false;
  bool isMovementDetected = false;

  void toggleProtection() {
    showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Security Control'),
            content: Text(
              isProtected
                  ? 'Disable security system?'
                  : 'Enable security system?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isProtected = !isProtected;
                    eventLog.add(
                      '${DateTime.now()} - ${
                          isProtected ? 'Enabled' : 'Disabled'
                      }',
                    );
                  });
                  Navigator.pop(context);
                },
                child: Text(isProtected ? 'Disable' : 'Enable'),
              ),
            ],
          ),
    );
  }

  void openPage(Widget page) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void onDoorStateChanged(bool isOpen) {
    setState(() => isDoorOpen = isOpen);
    if (isProtected && isOpen) {
      eventLog.add('${DateTime.now()} - Door opened (Security breach!)');
    }
  }

  void onWindowStateChanged(bool isOpen) {
    setState(() => isWindowOpen = isOpen);
    if (isProtected && isOpen) {
      eventLog.add('${DateTime.now()} - Window opened (Security breach!)');
    }
  }

  void onSmokeDetectedChanged(bool isDetected) {
    setState(() => isSmokeDetected = isDetected);
    if (isProtected && isDetected) {
      eventLog.add('${DateTime.now()} - Smoke detected (Security breach!)');
    }
  }

  void onMovementDetectedChanged(bool isDetected) {
    setState(() => isMovementDetected = isDetected);
    if (isProtected && isDetected) {
      eventLog.add('${DateTime.now()} - Movement detected (Security breach!)');
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
            _buildSecurityStatusCard(),
            const SizedBox(height: 20),
            _buildControlButtons(),
            const SizedBox(height: 20),
            Expanded(child: _buildSensorList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityStatusCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              isProtected ? Icons.lock : Icons.lock_open,
              size: 50,
              color: isProtected ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 10),
            Text(
              isProtected
                  ? 'The house is protected.'
                  : 'The house is unprotected.',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _controlButton(Icons.lock, 'Protection', toggleProtection),
        _controlButton(
          Icons.thermostat,
          'Temperature',
          () => openPage(const HomeTemperaturePage()),
        ),
        _controlButton(
          Icons.notifications,
          'Signal',
          () => openPage(SignalPage(eventLog: eventLog)),
        ),
      ],
    );
  }

  Widget _buildSensorList() {
    return ListView(
      children: [
        _sensorTile(
          FontAwesomeIcons.doorClosed,
          'Entrance door',
          isDoorOpen,
          () {
            openPage(
              DoorPage(
                initialState: isDoorOpen,
                onStateChanged: onDoorStateChanged,
              ),
            );
          },
        ),
        _sensorTile(
          FontAwesomeIcons.windowRestore,
          'Windows',
          isWindowOpen,
          () {
            openPage(
              WindowPage(
                initialState: isWindowOpen,
                onStateChanged: onWindowStateChanged,
              ),
            );
          },
        ),
        _sensorTile(
          FontAwesomeIcons.fireExtinguisher,
          'Smoke detector',
          isSmokeDetected,
          () {
            openPage(
              SmokeDetectorPage(
                initialState: isSmokeDetected,
                onStateChanged: onSmokeDetectedChanged,
              ),
            );
          },
        ),
        _sensorTile(
          FontAwesomeIcons.personRunning,
          'Movement in the corridor',
          isMovementDetected,
          () {
            openPage(
              MovementPage(
                initialState: isMovementDetected,
                onStateChanged: onMovementDetectedChanged,
              ),
            );
          },
        ),
      ],
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
