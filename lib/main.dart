/* Honest Calorie, an open-source nutrition tracker
Copyright (C) 2024 Roman Zubin

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>. */

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:honest_calorie/src/components/journal_appbar.dart';
import 'package:honest_calorie/src/models/app_settings_model.dart';
import 'package:honest_calorie/src/pages/profile_page.dart';
import 'package:honest_calorie/src/pages/statistics_page.dart';
import 'package:honest_calorie/src/pages/journal_page.dart';
import 'package:honest_calorie/src/pages/food_page.dart';
import 'package:provider/provider.dart';

void main() async => runApp(const HonestCalorieApp());

class HonestCalorieApp extends StatelessWidget {
  const HonestCalorieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AppSettingsModel(),
      builder: (context, child) => MaterialApp(
        // Providing a restorationScopeId allows the Navigator built by the
        // MaterialApp to restore the navigation stack when a user leaves and
        // returns to the app after it has been killed while running in the
        // background.
        restorationScopeId: 'app',

        // Provide the generated AppLocalizations to the MaterialApp. This
        // allows descendant Widgets to display the correct translations
        // depending on the user's locale.
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
        ],

        // Use AppLocalizations to configure the correct application title
        // depending on the user's locale.
        //
        // The appTitle is defined in .arb files found in the localization
        // directory.
        onGenerateTitle: (BuildContext context) =>
            AppLocalizations.of(context)!.appTitle,

        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,

        home: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;

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
        title: [
          JournalAppBar(selectedDay: DateTime.now()),
          AppBar(
            title: const Text('Food'),
          ),
          AppBar(
            title: const Text('Statistics'),
          ),
          AppBar(
            title: const Text('Profile'),
          ),
        ][currentPageIndex],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.book_rounded),
            icon: Icon(Icons.book_outlined),
            label: 'Journal',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.fastfood_rounded),
            icon: Icon(Icons.fastfood_outlined),
            label: 'Food',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.line_axis),
            icon: Icon(Icons.line_axis_outlined),
            label: 'Statistics',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        selectedIndex: currentPageIndex,
      ),
      body: <Widget>[
        const JournalView(),
        const FoodPage(),
        const StatisticsPage(),
        const ProfilePage(),
      ][currentPageIndex],
    );
  }
}
