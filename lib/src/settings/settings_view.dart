/* Honest Calorie, an open-source nutrition tracker
Copyright (C) 2024 Roman Zubin

Full notice can be found at /lib/main.dart file. */

import 'package:flutter/material.dart';
import 'package:honest_calorie/src/settings/list_tile_switch.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.settingsController});

  static const routeName = '/settings';

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text('Theme'),
          trailing: DropdownButton<ThemeMode>(
            // Read the selected themeMode from the controller
            value: settingsController.themeMode,
            // Call the updateThemeMode method any time the user selects a theme.
            onChanged: settingsController.updateThemeMode,
            items: const [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text('System Theme'),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text('Light Theme'),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text('Dark Theme'),
              )
            ],
          ),
        ),
        ListTileSwitch(
          title: const Text('Relative date'),
          value: settingsController.relativeDates,
          valueSetter: settingsController.updateRelativeDates,
        ),
      ],
    );
  }
}
