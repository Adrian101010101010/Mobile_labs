part of 'package:mobile_labs/cubit/setup_device_cubit.dart';

enum SetupStatus { initial, loading, success, failure }

class SetupDeviceState {
  final String? topic;
  final bool hasScanned;
  final SetupStatus status;
  final String? errorMessage;

  const SetupDeviceState({
    this.topic,
    this.hasScanned = false,
    this.status = SetupStatus.initial,
    this.errorMessage,
  });

  SetupDeviceState copyWith({
    String? topic,
    bool? hasScanned,
    SetupStatus? status,
    String? errorMessage,
  }) {
    return SetupDeviceState(
      topic: topic ?? this.topic,
      hasScanned: hasScanned ?? this.hasScanned,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
