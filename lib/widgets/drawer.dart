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
import 'package:honest_calorie/localizations.dart';
import 'package:honest_calorie/screens/forms/profile_edit_screen.dart';
import 'package:honest_calorie/main.dart';
import 'package:honest_calorie/routes.dart';
import 'package:honest_calorie/widgets/open_url.dart';

import '../types/product_db_screen_arguments.dart';

class AppDrawer extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Container(
              //alignment: Alignment.bottomLeft,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.bottomLeft,
                    margin: EdgeInsets.only(left: 10),
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage("https://i.imgur.com/vM4jpQH.png"),
                      radius: 32,
                    ),
                  ),
                  ListTile(
                    // TODO: localization
                    // TOOD: data is not updated since it's a stateless widget
                    title: Text(user.name == "" ? "User" : user.name),
                    subtitle: user.getSummaryData() == null
                        ? null
                        : Text(user.getSummaryData()!),
                    trailing: Icon(Icons.edit),
                    onTap: () {
                      // TODO: redraw drawer after changes
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileEdit()));
                    },
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(color: Colors.green[100]),
          ),
          ListTile(
              selected: currentScreen == "journal",
              title: Text(AppLocalizations.of(context).translate("journal")),
              leading: Icon(Icons.book),
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.journal);
                currentScreen = "journal";
              }),
          ListTile(
              selected: currentScreen == "products",
              title: Text(AppLocalizations.of(context).translate("products")),
              leading: Icon(Icons.fastfood),
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.product_db,
                    arguments: new ProductDBScreenArguments(isPicker: false));
                currentScreen = "products";
              }),
          ListTile(
              selected: currentScreen == "statistics",

              /// TODO: remove disabler
              enabled: false,
              title: Text(AppLocalizations.of(context).translate("statistics")),
              leading: Icon(Icons.data_usage),
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.statistics);
                currentScreen = "statistics";
              }),
          Divider(),
          ListTile(
              selected: currentScreen == "settings",
              title: Text(AppLocalizations.of(context).translate("settings")),
              leading: Icon(Icons.settings),
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.settings);
                currentScreen = "settings";
              }),
          if (settings.showFeedback)
            ListTile(
              title:
                  Text(AppLocalizations.of(context).translate("report_issue")),
              leading: Icon(Icons.bug_report),
              onTap: () => openURL(context,
                  "https://github.com/utkabulka/honest_calorie/issues"),
            ),
          Divider(),
          ListTile(
              selected: currentScreen == "about",
              title: Text(AppLocalizations.of(context).translate("about")),
              leading: Icon(Icons.help),
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.about);
                currentScreen = "about";
              }),
        ],
      ),
    );
  }
}
