import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubit/temperature_cubit.dart';

class HomeTemperaturePage extends StatelessWidget {
  const HomeTemperaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TemperatureCubit(),
      child: const _TemperatureView(),
    );
  }
}

class _TemperatureView extends StatefulWidget {
  const _TemperatureView();

  @override
  State<_TemperatureView> createState() => _TemperatureViewState();
}

class _TemperatureViewState extends State<_TemperatureView> {
  late TemperatureCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<TemperatureCubit>();
  }

  @override
  void dispose() {
    _cubit.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Temperature at home')),
      body: Center(
        child: BlocBuilder<TemperatureCubit, String?>(
          builder: (context, temperature) {
            if (temperature != null) {
              return Text(
                'Temperature: $temperature °C',
                style: const TextStyle(fontSize: 24),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
