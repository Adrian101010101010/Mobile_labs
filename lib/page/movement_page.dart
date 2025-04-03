import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_labs/abstract_class/toggleable_page.dart';

class MovementPage extends ToggleablePage {
  const MovementPage({
    required super.initialState,
    required super.onStateChanged,
    super.key,
  });

  @override
  ToggleablePageState createState() => _MovementPageState();
}

class _MovementPageState extends ToggleablePageState<MovementPage> {
  @override
  String getTitle() => 'Movement in Corridor';

  @override
  IconData getIcon(bool isActive) =>
      isActive ? FontAwesomeIcons.personWalking : FontAwesomeIcons.circleXmark;

  @override
  Color getColor(bool isActive) => isActive ? Colors.red : Colors.green;

  @override
  String getButtonText(bool isActive) =>
      isActive ? 'Stop Movement' : 'Detect Movement';
}
