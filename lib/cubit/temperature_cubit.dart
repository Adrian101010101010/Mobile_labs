import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_labs/services/mqtt_service.dart';

class TemperatureCubit extends Cubit<String?> {
  late final MQTTService _mqttService;

  TemperatureCubit()
      : super(null) {
    _mqttService = MQTTService(
      broker: dotenv.env['MQTT_BROKER']!,
      topic: 'sensor/temperature',
      username: dotenv.env['MQTT_USERNAME']!,
      password: dotenv.env['MQTT_PASSWORD']!,
      onMessageReceived: emit,
    );

    _mqttService.connect();
  }

  void disconnect() {
    _mqttService.disconnect();
  }
}
