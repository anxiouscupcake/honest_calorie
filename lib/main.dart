/* Honest Calorie, an open-source nutrition tracker
Copyright (C) 2025 Nicole Zubina

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
import 'package:honest_calorie/src/components/settings_button.dart';
import 'package:honest_calorie/src/models/app_settings_model.dart';
import 'package:honest_calorie/src/models/food_model.dart';
import 'package:honest_calorie/src/models/journal_model.dart';
import 'package:honest_calorie/src/models/profile_model.dart';
import 'package:honest_calorie/src/pages/profile_page.dart';
import 'package:honest_calorie/src/pages/statistics_page.dart';
import 'package:honest_calorie/src/pages/journal_page.dart';
import 'package:honest_calorie/src/pages/food_page.dart';
import 'package:provider/provider.dart';

void main() async => runApp(const CalorieApp());

class CalorieApp extends StatefulWidget {
  const CalorieApp({super.key});

  @override
  State<StatefulWidget> createState() => _CalorieAppState();
}

class _CalorieAppState extends State<CalorieApp> {
  late AppSettingsModel appSettingsModel;

  @override
  void initState() {
    super.initState();
    appSettingsModel = AppSettingsModel();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => appSettingsModel,
      child: Consumer<AppSettingsModel>(
        builder: (context, value, child) {
          return MaterialApp(
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
            themeMode: value.getThemeMode(),

            home: MultiProvider(
              providers: [
                Provider(create: (context) => AppSettingsModel()),
                Provider(create: (context) => ProfileModel()),
                Provider(create: (context) => FoodModel()),
                Provider(create: (context) => JournalModel()),
              ],
              child: const MainPage(),
            ),
          );
        },
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

  static const pageNames = [
    "Journal",
    "Food",
    "Statistics",
    "Profile",
  ];

  late JournalModel journalModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    journalModel = Provider.of(context);
  }

  List<Widget> getAppBarActions() {
    List<Widget> widgets = List.empty(growable: true);
    if (currentPageIndex == 0) {
      widgets.add(IconButton(
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                lastDate: DateTime(3000),
                currentDate: journalModel.selectedDate);
            if (selectedDate != null) {
              setState(() => journalModel.selectedDate = selectedDate);
            }
          },
          icon: const Icon(Icons.calendar_month_rounded)));
    }
    widgets.add(const SettingsButton());
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageNames[currentPageIndex]),
        actions: getAppBarActions(),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: const Icon(Icons.book_rounded),
            icon: const Icon(Icons.book_outlined),
            label: pageNames[0],
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.fastfood_rounded),
            icon: const Icon(Icons.fastfood_outlined),
            label: pageNames[1],
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.insert_chart_rounded),
            icon: const Icon(Icons.insert_chart_outlined_rounded),
            label: pageNames[2],
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.person),
            icon: const Icon(Icons.person_outline),
            label: pageNames[3],
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
