/* Honest Calorie, an open-source nutrition tracker
Copyright (C) 2025 Nicole Zubina

Full notice can be found at /lib/main.dart file. */

import 'package:flutter/material.dart';

class AppSettingsModel extends ChangeNotifier {
  bool _themeFollowSystem = true;
  bool get themeFollowSystem => _themeFollowSystem;
  set themeFollowSystem(bool value) {
    _themeFollowSystem = value;
    notifyListeners();
  }

  bool _themeDark = true;
  bool get themeDark => _themeDark;
  set themeDark(bool value) {
    _themeDark = value;
    notifyListeners();
  }

  ThemeMode getThemeMode() {
    if (themeFollowSystem) {
      return ThemeMode.system;
    } else {
      return themeDark ? ThemeMode.dark : ThemeMode.light;
    }
  }

  // TODO: implement metric and imperial measurements
  bool useMetric = true;

  // journal settings
  bool relativeDates = true;
}
