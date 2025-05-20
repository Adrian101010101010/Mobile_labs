import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/services/mqtt_service.dart';

class TemperatureCubit extends Cubit<String?> {
  late final MQTTService _mqttService;

  TemperatureCubit()
      : super(null) {
    _mqttService = MQTTService(
      broker: '76c4961e76394de3ad025d878ef7973d.s1.eu.hivemq.cloud',
      topic: 'sensor/temperature',
      username: 'Users',
      password: 'Lb1234567890',
      onMessageReceived: emit,
    );

    _mqttService.connect();
  }

  void disconnect() {
    _mqttService.disconnect();
  }
}
