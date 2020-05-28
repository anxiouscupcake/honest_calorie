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

class CategorySelector extends StatelessWidget {
  /// Locale key for the title
  final String titleKey;

  /// List of locale keys to show.
  final List<String> categoryKeys;

  const CategorySelector(
      {Key key, @required this.titleKey, @required this.categoryKeys})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate(titleKey)),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: categoryKeys.length,
          itemBuilder: (context, index) {
            return Column(children: <Widget>[
              ListTile(
                title: Text(AppLocalizations.of(context).translate(categoryKeys[index])),
                onTap: () {
                  Navigator.pop(context, categoryKeys[index]);
                },
              ),
              Divider(),
            ],);
          }),
    );
  }
}
