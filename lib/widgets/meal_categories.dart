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

class MealCategoriesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MealCategoriesState();
}

class _MealCategoriesState extends State<MealCategoriesScreen> {
  List<String> _categories = <String>[];

  _editCategory(BuildContext context, int index) async {
    String input = "";
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: index >= 0
                ? Text("Edit name of the category:")
                : Text("Add new category"),
            content: new Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                        text: index >= 0 ? settings.mealCategories[index] : ""),
                    decoration: InputDecoration(labelText: "Category name"),
                    autofocus: true,
                    onChanged: (String value) {
                      input = value;
                    },
                  ),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              FlatButton(
                  onPressed: () {
                    if (input != "") {
                      if (index >= 0) {
                        settings.mealCategories[index] = input;
                      } else {
                        settings.mealCategories.add(input);
                      }
                    }
                    Navigator.pop(context);
                  },
                  child: Text("OK")),
            ],
          );
        });
  }

  _updateList() {
    _categories = [];
    for (String category in settings.mealCategories) {
      _categories.add(category);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_categories == null) _updateList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit categories"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          setState(() {
            String old = settings.mealCategories[oldIndex];
            String oldCategory = _categories[oldIndex];
            if (oldIndex > newIndex) {
              for (int i = oldIndex; i > newIndex; i--) {
                settings.mealCategories[i] = settings.mealCategories[i - 1];
                _categories[i] = _categories[i - 1];
              }
              settings.mealCategories[newIndex] = old;
              _categories[newIndex] = oldCategory;
            } else {
              for (int i = oldIndex; i < newIndex - 1; i++) {
                settings.mealCategories[i] = settings.mealCategories[i + 1];
                _categories[i] = _categories[i + 1];
              }
              settings.mealCategories[newIndex - 1] = old;
              _categories[newIndex - 1] = oldCategory;
            }
            _updateList();
          });
        },
        children: <Widget>[
          for (var i = 0; i < settings.mealCategories.length; i++)
            ListTile(
              key: ValueKey(settings.mealCategories[i]),
              leading: Icon(Icons.reorder),
              title: Text(settings.mealCategories[i]),
              onTap: () async {
                await _editCategory(context, i);
                setState(() {});
              },
            ),
        ],
      ),
    );
  }
}
