import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_labs/shared/toggleable_page.dart';

class DoorPage extends ToggleablePage {
  const DoorPage({
    required super.initialState,
    required super.onStateChanged,
    super.key,
  });

  @override
  ToggleablePageState createState() => _DoorPageState();
}

class _DoorPageState extends ToggleablePageState<DoorPage> {
  @override
  String getTitle() => 'Entrance Door';

  @override
  IconData getIcon(bool isActive) =>
      isActive ? FontAwesomeIcons.doorOpen : FontAwesomeIcons.doorClosed;

  @override
  Color getColor(bool isActive) => isActive ? Colors.red : Colors.green;

  @override
  String getButtonText(bool isActive) => isActive ? 'Close Door' : 'Open Door';
}
