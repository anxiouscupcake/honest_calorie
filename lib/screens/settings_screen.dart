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
import 'package:honest_calorie/main.dart';
import 'package:honest_calorie/widgets/drawer.dart';
import 'package:honest_calorie/widgets/meal_categories.dart';
import 'package:honest_calorie/screens/forms/profile_edit_screen.dart';
import 'package:honest_calorie/localizations.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = "/settings";
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    // тут стоит сделать экран загрузки пока настройки не загрузятся
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate("settings")),
        ),
        body: ListView(
          children: [
            /*
            ListTile(
              leading: Icon(Icons.language),
              title: Text(AppLocalizations.of(context).translate("language")),
              subtitle: Text(AppLocalizations.of(context).translate("language_sub")),
              onTap: () {
                //
              },
            ),
            */
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                  AppLocalizations.of(context).translate("edit_profile_data")),
              subtitle: Text(AppLocalizations.of(context)
                  .translate("edit_profile_data_sub")),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileEdit())),
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text(AppLocalizations.of(context)
                  .translate("edit_meal_categories")),
              subtitle: Text(AppLocalizations.of(context)
                  .translate("edit_meal_categories_sub")),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MealCategoriesScreen())),
            ),
            SwitchListTile(
                secondary: Icon(Icons.bug_report),
                title: Text("Show feedback button"),
                subtitle: Text("Shows feedback button in drawer"),
                value: settings.showFeedback,
                onChanged: (bool value) async {
                  setState(() {
                    settings.showFeedback = value;
                  });
                  settings.save();
                }),
            SwitchListTile(
              secondary: Icon(Icons.settings),
              title: Text("Water tracking"),
              subtitle:
                  Text("Toggles water tracking functionality"),
              value: settings.waterTracking,
              onChanged: null,
            ),
            Divider(),
            // TODO: implement import/export
            ListTile(
              title: Text("Import/Export data"),
              subtitle: Text("Import or export data from or to a file"),
              leading: Icon(Icons.import_export),
              onTap: () {
                return;
              },
            ),
          ],
        ));
  }
}
