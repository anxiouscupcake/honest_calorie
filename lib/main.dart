// Copyright (C) 2021 Roman Zubin
//
// This file is part of Honest Calorie.
//
// Honest Calorie is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Honest Calorie is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Honest Calorie.  If not, see <http://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// data
import 'package:honest_calorie/data/settings.dart';
import 'package:honest_calorie/data/user.dart';
import 'package:honest_calorie/data/product_db.dart';
import 'package:honest_calorie/data/journal_db.dart';
import 'package:honest_calorie/localizations.dart';

// screens
import 'package:honest_calorie/routes.dart';
import 'package:honest_calorie/screens/journal_screen.dart';
import 'package:honest_calorie/screens/product_db_screen.dart';
import 'package:honest_calorie/screens/settings_screen.dart';
import 'package:honest_calorie/screens/statistics_screen.dart';

import 'screens/product_db_screen.dart';

late Settings settings;
late User user;
late ProductDatabase products;
late JournalDatabase journal;

/// Used to determine what tile needs to be selected in drawer.dart.
String currentScreen = "journal";

const bool isRelease = bool.fromEnvironment('dart.vm.product');

void main() {
  /*
  if (isRelease) {
    debugPrint = (String message, {int wrapWidth}) {};
  }
  */
  runApp(MyApp());
}

Future _loadData() async {
  Stopwatch loadingTime = new Stopwatch();
  loadingTime.start();

  List<Future> futures = [];
  settings = new Settings();
  futures.add(settings.load());
  user = new User();
  futures.add(user.load());
  journal = new JournalDatabase();
  futures.add(journal.load());
  products = new ProductDatabase();
  futures.add(products.load());
  await Future.wait(futures);

  loadingTime.stop();
  debugPrint("DEBUG: Total loading time: " +
      loadingTime.elapsedMilliseconds.toString() +
      "ms");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _loadData();
    return MaterialApp(
      title: "Nutrition Tracker",
      home: JournalScreen(),
      theme: ThemeData(
        primaryColor: Colors.green,
        accentColor: Colors.green[400],
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green[400],
        ),
      ),
      // routes
      routes: {
        Routes.journal: (context) => JournalScreen(),
        Routes.product_db: (context) => ProductDBScreen(),
        Routes.statistics: (context) => StatisticsScreen(),
        Routes.settings: (context) => SettingsScreen(),
      },
      // locales
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("ru"), // Russian
        const Locale("en"), // English
      ],
    );
  }
}
