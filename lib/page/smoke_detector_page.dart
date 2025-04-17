import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_labs/shared/toggleable_page.dart';

class SmokeDetectorPage extends ToggleablePage {
  const SmokeDetectorPage({
    required super.initialState,
    required super.onStateChanged,
    super.key,
  });

  @override
  ToggleablePageState createState() => _SmokeDetectorPageState();
}

class _SmokeDetectorPageState extends ToggleablePageState<SmokeDetectorPage> {
  @override
  String getTitle() => 'Smoke Detector';

  @override
  IconData getIcon(bool isActive) =>
      isActive ? FontAwesomeIcons.fireExtinguisher : FontAwesomeIcons.smoking;

  @override
  Color getColor(bool isActive) => isActive ? Colors.red : Colors.green;

  @override
  String getButtonText(bool isActive) =>
      isActive ? 'Clear Smoke' : 'Detect Smoke';
}
