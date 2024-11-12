/* Honest Calorie, an open-source nutrition tracker
Copyright (C) 2024 Roman Zubin

Full notice can be found at /lib/main.dart file. */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:honest_calorie/src/components/list_tile_switch.dart';
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
    return ListView(
      children: [],
    );
  }
}
