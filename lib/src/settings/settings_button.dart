import 'package:flutter/material.dart';
import 'package:honest_calorie/src/settings/settings_controller.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () {}, icon: const Icon(Icons.settings));
  }
}
