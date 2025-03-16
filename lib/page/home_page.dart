import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/app_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Security')),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.shield,
                      size: 50,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "The house is protected.",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _controlButton(Icons.lock, "Protection"),
                _controlButton(Icons.videocam, "Cameras"),
                _controlButton(Icons.notifications, "Signal"),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  _sensorTile(FontAwesomeIcons.doorClosed, "Entrance door", "Closed"),
                  _sensorTile(FontAwesomeIcons.windowRestore, "Windows", "Closed"),
                  _sensorTile(FontAwesomeIcons.fireExtinguisher, "Smoke detector", "Norm"),
                  _sensorTile(FontAwesomeIcons.running, "Movement in the corridor", "Not recorded"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _controlButton(IconData icon, String label) {
    return Column(
      children: [
        FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.blueGrey,
          child: Icon(icon, size: 28),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _sensorTile(IconData icon, String title, String status) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, size: 28, color: Colors.blueGrey),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(status, style: TextStyle(color: status == "Norm" ? Colors.green : Colors.red)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      ),
    );
  }
}