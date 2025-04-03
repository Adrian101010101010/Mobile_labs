import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_labs/abstract_class/toggleable_page.dart';

class WindowPage extends ToggleablePage {
  const WindowPage({
    required super.initialState,
    required super.onStateChanged,
    super.key,
  });

  @override
  ToggleablePageState createState() => _WindowPageState();
}

class _WindowPageState extends ToggleablePageState<WindowPage> {
  @override
  String getTitle() => 'Windows';

  @override
  IconData getIcon(bool isActive) =>
      isActive
          ? FontAwesomeIcons.windowMaximize
          : FontAwesomeIcons.windowRestore;

  @override
  Color getColor(bool isActive) => isActive ? Colors.green : Colors.red;

  @override
  String getButtonText(bool isActive) =>
      isActive ? 'Close Window' : 'Open Window';
}
