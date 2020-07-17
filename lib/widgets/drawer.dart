// Copyright (C) 2020 Roman Zubin
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
import 'package:nutrition_tracker/localizations.dart';
import 'package:nutrition_tracker/screens/forms/profile_edit_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nutrition_tracker/main.dart';
import 'package:nutrition_tracker/routes.dart';
import 'package:nutrition_tracker/types/product_db_screen_arguments.dart';

class AppDrawer extends StatelessWidget {
  // temporary dialog
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch URL: " + url;
    }
  }

  Future<void> _goToURL(BuildContext context, String url) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
                "В браузере откроется этот URL: " + url + "\n\nПродолжить?"),
            children: <Widget>[
              Row(
                children: <Widget>[
                  SimpleDialogOption(
                    child: Text("Yes"),
                    onPressed: () {
                      _launchURL(url);
                      Navigator.pop(context);
                    },
                  ),
                  SimpleDialogOption(
                    child: Text("No"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            ],
          );
        });
  }

  Widget _showWaterTracking(BuildContext context) {
    return ListTile(
      // TODO: remove disabler
      enabled: false,
      selected: currentScreen == "water tracking",
      title: Text("Water tracking"),
      leading: Icon(Icons.settings),
      onTap: () {
        // TODO: implement ontap
      },
    );
  }

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
                    title: Text("Jopa"),
                    subtitle: Text("63kg, BMI: 228"),
                    trailing: Icon(Icons.edit),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileEditScreen()));
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
          if (settings.waterTracking) _showWaterTracking(context),
          ListTile(
              selected: currentScreen == "products",
              title: Text(AppLocalizations.of(context).translate("products")),
              leading: Icon(Icons.fastfood),
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.product_db,
                    arguments: ProductDBScreenArguments(false));
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
              title: Text(AppLocalizations.of(context).translate("report_bug")),
              leading: Icon(Icons.bug_report),
              onTap: () =>
                  _goToURL(context, "https://forms.gle/YLX9CXJx5d3xgHV16"),
            ),
          if (settings.showFeedback)
            ListTile(
              title:
                  Text(AppLocalizations.of(context).translate("give_feedback")),
              leading: Icon(Icons.bug_report),
              onTap: () =>
                  _goToURL(context, "https://forms.gle/FNS8j6boTuAn7usn6"),
            ),
          Divider(),
          ListTile(
              selected: currentScreen == "about",
              title: Text(AppLocalizations.of(context).translate("about")),
              leading: Icon(Icons.help),
              onTap: () {
                // TODO: implement about screen
                currentScreen = "about";
              }),
        ],
      ),
    );
  }
}
