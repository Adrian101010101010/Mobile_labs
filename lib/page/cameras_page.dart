import 'package:flutter/material.dart';
import 'package:mobile_labs/services/mqtt_service.dart';

class HomeTemperaturePage extends StatefulWidget {
  const HomeTemperaturePage({super.key});

  @override
  State<HomeTemperaturePage> createState() => _HomeTemperaturePageState();
}

class _HomeTemperaturePageState extends State<HomeTemperaturePage> {
  late MQTTService _mqttService;
  String? _temperature;

  @override
  void initState() {
    super.initState();
    _mqttService = MQTTService(
      broker: '76c4961e76394de3ad025d878ef7973d.s1.eu.hivemq.cloud',
      topic: 'sensor/temperature',
      username: 'Users',
      password: 'Lb1234567890',
      onMessageReceived: (message) {
        setState(() {
          _temperature = message;
        });
      },
    );
    _mqttService.connect();
  }

  @override
  void dispose() {
    _mqttService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Temperature at home')),
      body: Center(
        child: _temperature != null
            ? Text(
          'Temperature: $_temperature °C',
          style: const TextStyle(fontSize: 24),
        )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
