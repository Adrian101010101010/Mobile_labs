import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_labs/page/device_status_page.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';


class SetupDevicePage extends StatefulWidget {
  const SetupDevicePage({super.key});

  @override
  State<SetupDevicePage> createState() => _SetupDevicePageState();
}

class _SetupDevicePageState extends State<SetupDevicePage> {
  String? topic;
  bool hasScanned = false;

  void handleScan(BarcodeCapture capture) {
    if (hasScanned) return;

    final String? code = capture.barcodes.first.rawValue;
    if (code == null) return;

    setState(() {
      topic = code;
      hasScanned = true;
    });

    _showCredentialsDialog(code);
  }

  void _showCredentialsDialog(String topic) {
    final loginController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Введіть логін та пароль'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: loginController,
              decoration: const InputDecoration(labelText: 'Логін'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final login = loginController.text;
              final password = passwordController.text;
              final payload = '{"login": "$login", "password": "$password"}';
              await sendCredentialsToMQTT(
                  topic,
                  payload,
                  'apeka',
                  'lB12345678',
              );

              if (!mounted) return;
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute<Widget>(
                  builder: (_) => DeviceStatusPage(topic: topic),
                ),
              );
            },
            child: const Text('Надіслати'),
          ),
        ],
      ),
    );
  }

  Future<void> sendCredentialsToMQTT(
      String topic,
      String payload,
      String mqttLogin,
      String mqttPassword,
      ) async {
    final client = MqttServerClient.withPort(
      'f300bdef93c147389bfb597bb73d16d0.s1.eu.hivemq.cloud',
      'flutter_client',
      8883,
    );

    client.logging(on: false);
    client.secure = true;
    client.keepAlivePeriod = 20;
    client.setProtocolV311();
    client.securityContext = SecurityContext.defaultContext;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .authenticateAs(mqttLogin, mqttPassword)
        .withWillQos(MqttQos.atMostOnce);

    client.connectionMessage = connMessage;

    try {
      final status = await client.connect();
      if (status?.state != MqttConnectionState.connected) {
        throw Exception('MQTT connection failed: ${status?.state}');
      }

      final builder = MqttClientPayloadBuilder();
      builder.addString(payload);

      client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
      debugPrint('MQTT опубліковано до $topic: $payload');

      await Future<void>.delayed(const Duration(seconds: 1));
      client.disconnect();
    } catch (e) {
      debugPrint('MQTT помилка: $e');
      client.disconnect();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сканування пристрою')),
      body: MobileScanner(
        controller: MobileScannerController(),
        onDetect: handleScan,
      ),
    );
  }
}
