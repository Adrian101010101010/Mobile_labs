import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubit/setup_device_cubit.dart';
import 'package:mobile_labs/page/device_status_page.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class SetupDevicePage extends StatelessWidget {
  const SetupDevicePage({super.key});

  void _handleScan(BuildContext context, BarcodeCapture capture) {
    final cubit = context.read<SetupDeviceCubit>();
    if (cubit.state.hasScanned) return;

    final code = capture.barcodes.first.rawValue;
    if (code == null) return;

    cubit.scanTopic(code);
    _showCredentialsDialog(context, code);
  }

  void _showCredentialsDialog(BuildContext context, String topic) {
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
          BlocBuilder<SetupDeviceCubit, SetupDeviceState>(
            builder: (context, state) {
              return TextButton(
                onPressed: () async {
                  final login = loginController.text;
                  final password = passwordController.text;

                  await context.read<SetupDeviceCubit>().sendCredentials(
                    topic: topic,
                    login: login,
                    password: password,
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute<Widget>(
                        builder: (_) => DeviceStatusPage(topic: topic),
                      ),
                    );
                  }
                },
                child: state.status == SetupStatus.loading
                    ? const CircularProgressIndicator()
                    : const Text('Надіслати'),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SetupDeviceCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Сканування пристрою')),
        body: MobileScanner(
          controller: MobileScannerController(),
          onDetect: (capture) => _handleScan(context, capture),
        ),
      ),
    );
  }
}
