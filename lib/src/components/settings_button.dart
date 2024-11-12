/* Honest Calorie, an open-source nutrition tracker
Copyright (C) 2024 Roman Zubin

Full notice can be found at /lib/main.dart file. */

import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () {}, icon: const Icon(Icons.settings));
  }
}
