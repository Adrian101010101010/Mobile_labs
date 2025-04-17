import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

abstract class ToggleablePage extends StatefulWidget {
  final bool initialState;
  final void Function(bool) onStateChanged;

  const ToggleablePage({
    required this.initialState,
    required this.onStateChanged,
    super.key,
  });

  @override
  ToggleablePageState createState();
}

abstract class ToggleablePageState<T extends ToggleablePage> extends State<T> {
  late bool _isActive;
  Timer? _sensorTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _isActive = widget.initialState;
    _startAutoUpdate();
  }

  void _toggleState() {
    setState(() {
      _isActive = !_isActive;
    });
    widget.onStateChanged(_isActive);
  }

  void _startAutoUpdate() {
    _sensorTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final bool newState = _random.nextBool();
      if (newState != _isActive) {
        setState(() {
          _isActive = newState;
        });
        widget.onStateChanged(_isActive);
      }
    });
  }

  String getTitle();
  IconData getIcon(bool isActive);
  Color getColor(bool isActive);
  String getButtonText(bool isActive);

  @override
  void dispose() {
    _sensorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(getTitle())),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(getIcon(_isActive), size: 100, color: getColor(_isActive)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleState,
              child: Text(getButtonText(_isActive)),
            ),
          ],
        ),
      ),
    );
  }
}
