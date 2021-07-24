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
import 'package:url_launcher/url_launcher.dart';

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw "Could not launch URL: " + url;
  }
}

Future<void> openURL(BuildContext context, String url) async {
  return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(AppLocalizations.of(context).translate("this_link_will_open") + 
            url + "\n\n" + AppLocalizations.of(context).translate("ask_to_continue")),
          children: <Widget>[
            Row(
              children: <Widget>[
                SimpleDialogOption(
                  child: Text(AppLocalizations.of(context).translate("yes")),
                  onPressed: () {
                    _launchURL(url);
                    Navigator.pop(context);
                  },
                ),
                SimpleDialogOption(
                  child: Text(AppLocalizations.of(context).translate("no")),
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