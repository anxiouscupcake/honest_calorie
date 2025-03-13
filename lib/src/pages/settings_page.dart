/* Honest Calorie, an open-source nutrition tracker
Copyright (C) 2025 Nicole Zubina

Full notice can be found at /lib/main.dart file. */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:honest_calorie/src/models/app_settings_model.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static const routeName = '/settings';

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late AppSettingsModel appSettingsModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appSettingsModel = Provider.of<AppSettingsModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text("Theme"),
            trailing: DropdownButton<ThemeMode>(
              value: appSettingsModel.themeMode,
              items: const [
                DropdownMenuItem<ThemeMode>(
                  value: ThemeMode.system,
                  child: Text("System"),
                ),
                DropdownMenuItem<ThemeMode>(
                  value: ThemeMode.light,
                  child: Text("Light"),
                ),
                DropdownMenuItem<ThemeMode>(
                  value: ThemeMode.dark,
                  child: Text("Dark"),
                ),
              ],
              onChanged: (value) => setState(
                  () => appSettingsModel.themeMode = value ?? ThemeMode.system),
            ),
          ),
          ListTile(
              leading: const Icon(Icons.abc),
              title: const Text("Use metric system"),
              trailing: Switch(
                value: appSettingsModel.useMetric,
                onChanged: null,
              )),
          ListTile(
              leading: const Icon(Icons.calendar_month_outlined),
              title: const Text("Relative dates"),
              trailing: Switch(
                value: appSettingsModel.relativeDates,
                onChanged: null,
              )),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About"),
            onTap: () => showAboutDialog(context: context),
          ),
        ],
      ),
    );
  }
}
