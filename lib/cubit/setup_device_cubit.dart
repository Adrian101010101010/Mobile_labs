import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

part 'package:mobile_labs/shared/setup_device_state.dart';

class SetupDeviceCubit extends Cubit<SetupDeviceState> {
  SetupDeviceCubit() : super(const SetupDeviceState());

  void scanTopic(String topic) {
    emit(state.copyWith(topic: topic, hasScanned: true));
  }

  Future<void> sendCredentials({
    required String topic,
    required String login,
    required String password,
  }) async {
    emit(state.copyWith(status: SetupStatus.loading));

    final payload = '{"login": "$login", "password": "$password"}';

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
        .authenticateAs('apeka', 'lB12345678')
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

      await Future<void>.delayed(const Duration(seconds: 1));
      client.disconnect();

      emit(state.copyWith(status: SetupStatus.success));
    } catch (e) {
      debugPrint('MQTT помилка: $e');
      client.disconnect();
      emit(
        state.copyWith(status: SetupStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
