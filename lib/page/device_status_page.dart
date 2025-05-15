import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class DeviceStatusPage extends StatefulWidget {
  final String topic;
  const DeviceStatusPage({required this.topic, super.key});

  @override
  State<DeviceStatusPage> createState() => _DeviceStatusPageState();
}

class _DeviceStatusPageState extends State<DeviceStatusPage> {
  final List<String> messages = [];
  late MqttServerClient client;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    connectAndSubscribe(widget.topic);
    timer = Timer.periodic(const Duration(seconds: 3), (Timer t) {
      setState(() {});
    });
  }

  Future<void> connectAndSubscribe(String topic) async {
    client = MqttServerClient.withPort(
      'f300bdef93c147389bfb597bb73d16d0.s1.eu.hivemq.cloud',
      'flutter_subscriber_${DateTime.now().millisecondsSinceEpoch}',
      8883,
    );

    client.logging(on: false);
    client.secure = true;
    client.keepAlivePeriod = 20;
    client.setProtocolV311();
    client.securityContext = SecurityContext.defaultContext;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_subscriber')
        .authenticateAs('apeka', 'lB12345678')
        .withWillQos(MqttQos.atMostOnce);
    client.connectionMessage = connMessage;

    try {
      final connStatus = await client.connect();
      if (connStatus?.state != MqttConnectionState.connected) {
        throw Exception('MQTT connection failed: ${connStatus?.state}');
      }

      debugPrint('Підключено до MQTT');
      client.subscribe(topic, MqttQos.atLeastOnce);

      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> event) {
        final recMessage = event[0].payload as MqttPublishMessage;
        final message =
        MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);

        debugPrint('Отримано повідомлення: $message');
        messages.add(message);
      });
    } catch (e) {
      debugPrint('MQTT помилка підключення: $e');
      client.disconnect();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    client.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Стан пристрою')),
      body: messages.isEmpty
          ? const Center(child: Text('Очікуємо повідомлення...'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: messages.length,
        itemBuilder: (context, index) => Text('📩 ${messages[index]}'),
      ),
    );
  }
}
