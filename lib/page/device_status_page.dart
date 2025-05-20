import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubit/device_status_cubit.dart';

class DeviceStatusPage extends StatelessWidget {
  final String topic;
  const DeviceStatusPage({required this.topic, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeviceStatusCubit(topic: topic),
      child: Scaffold(
        appBar: AppBar(title: const Text('Стан пристрою')),
        body: BlocBuilder<DeviceStatusCubit, List<String>>(
          builder: (context, messages) {
            if (messages.isEmpty) {
              return const Center(child: Text('Очікуємо повідомлення...'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) => Text('📩 ${messages[index]}'),
            );
          },
        ),
      ),
    );
  }
}
