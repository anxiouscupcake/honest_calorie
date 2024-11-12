/* Honest Calorie, an open-source nutrition tracker
Copyright (C) 2024 Roman Zubin

Full notice can be found at /lib/main.dart file. */

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:honest_calorie/src/journal_view/journal_appbar.dart';
import 'package:honest_calorie/src/profile_view/profile_view.dart';
import 'package:honest_calorie/src/statistics_view/statistics_view.dart';
import 'settings/settings_controller.dart';
import 'package:honest_calorie/src/journal_view/journal_view.dart';
import 'package:honest_calorie/src/food_view/food_view.dart';

class App extends StatefulWidget {
  const App({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
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

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: widget.settingsController.themeMode,

          home: Scaffold(
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
              const FoodView(),
              const StatisticsView(),
              const ProfileView(),
            ][currentPageIndex],
          ),
        );
      },
    );
  }
}
