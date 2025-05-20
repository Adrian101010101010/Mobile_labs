import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class DeviceStatusCubit extends Cubit<List<String>> {
  final String topic;
  late final MqttServerClient _client;
  final List<String> _messages = [];

  DeviceStatusCubit({required this.topic}) : super([]) {
    _connectAndSubscribe();
  }

  Future<void> _connectAndSubscribe() async {
    _client = MqttServerClient.withPort(
      'f300bdef93c147389bfb597bb73d16d0.s1.eu.hivemq.cloud',
      'flutter_subscriber_${DateTime.now().millisecondsSinceEpoch}',
      8883,
    );

    _client.logging(on: false);
    _client.secure = true;
    _client.keepAlivePeriod = 20;
    _client.setProtocolV311();
    _client.securityContext = SecurityContext.defaultContext;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_subscriber')
        .authenticateAs('apeka', 'lB12345678')
        .withWillQos(MqttQos.atMostOnce);

    _client.connectionMessage = connMessage;

    try {
      final connStatus = await _client.connect();
      if (connStatus?.state != MqttConnectionState.connected) {
        throw Exception('MQTT connection failed: ${connStatus?.state}');
      }

      _client.subscribe(topic, MqttQos.atLeastOnce);

      _client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> event) {
        final recMessage = event[0].payload as MqttPublishMessage;
        final message = MqttPublishPayload.bytesToStringAsString(
          recMessage.payload.message,
        );
        _messages.add(message);
        emit(List.from(_messages));
      });
    } catch (e) {
      debugPrint('MQTT помилка підключення: $e');
      _client.disconnect();
    }
  }

  void disconnect() {
    _client.disconnect();
  }

  @override
  Future<void> close() {
    disconnect();
    return super.close();
  }
}
