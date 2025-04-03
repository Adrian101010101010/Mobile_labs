import 'package:flutter/material.dart';

class SignalPage extends StatelessWidget {
  final List<String> eventLog;

  const SignalPage({required this.eventLog, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security Log')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            eventLog.isEmpty
                ? const Center(
                  child: Text(
                    'No security events recorded.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
                : ListView.builder(
                  itemCount: eventLog.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Icon(
                          eventLog[index].contains('Security breach!')
                              ? Icons.security
                              : Icons.warning,
                          color:
                              eventLog[index].contains('Security breach!')
                                  ? Colors.red
                                  : Colors.green,
                        ),
                        title: Text(eventLog[index]),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
