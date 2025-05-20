import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubit/signal_cubit.dart';

class SignalPage extends StatelessWidget {
  const SignalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignalCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Security Log'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => context.read<SignalCubit>().clearEvents(),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<SignalCubit, List<String>>(
            builder: (context, eventLog) {
              if (eventLog.isEmpty) {
                return const Center(
                  child: Text(
                    'No security events recorded.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              }

              return ListView.builder(
                itemCount: eventLog.length,
                itemBuilder: (context, index) {
                  final event = eventLog[index];
                  final isBreach = event.contains('Security breach!');

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Icon(
                        isBreach ? Icons.security : Icons.warning,
                        color: isBreach ? Colors.red : Colors.green,
                      ),
                      title: Text(event),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
