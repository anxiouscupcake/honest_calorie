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

// TODO: localize meal categories screen
class MealCategoriesScreen extends StatefulWidget {
  final bool? isEditing;

  const MealCategoriesScreen({
    @required this.isEditing,
  });

  @override
  State<StatefulWidget> createState() => new _MealCategoriesState();
}

class _MealCategoriesState extends State<MealCategoriesScreen> {
  _editCategory(BuildContext context, int index) async {
    late bool isEditingCategory;
    if (index >= 0) {
      isEditingCategory = true;
    } else {
      isEditingCategory = false;
    }

    String input = "";
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title:
                index >= 0 ? Text("Edit category:") : Text("Add new category"),
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
              if (isEditingCategory)
                TextButton(
                    onPressed: () {
                      settings.mealCategories.removeAt(index);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.red.shade900,
                      ),
                    )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    if (input != "") {
                      if (isEditingCategory) {
                        settings.mealCategories[index] = input;
                      } else {
                        settings.mealCategories.add(input);
                      }
                    }
                    Navigator.pop(context);
                    settings.save();
                  },
                  child: Text("OK")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit categories"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await _editCategory(context, -1);
              setState(() {});
            },
          ),
        ],
      ),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          setState(() {
            String oldCategory = settings.mealCategories[oldIndex];
            if (oldIndex > newIndex) {
              for (int i = oldIndex; i > newIndex; i--) {
                settings.mealCategories[i] = settings.mealCategories[i - 1];
              }
              settings.mealCategories[newIndex] = oldCategory;
            } else {
              for (int i = oldIndex; i < newIndex - 1; i++) {
                settings.mealCategories[i] = settings.mealCategories[i + 1];
              }
              settings.mealCategories[newIndex - 1] = oldCategory;
            }
          });
        },
        children: <Widget>[
          for (var i = 0; i < settings.mealCategories.length; i++)
            ListTile(
              key: ValueKey(settings.mealCategories[i]),
              leading: Icon(Icons.reorder),
              title: Text(settings.mealCategories[i]),
              onTap: () async {
                if (widget.isEditing!) {
                  Navigator.pop(context, settings.mealCategories[i]);
                } else {
                  await _editCategory(context, i);
                  setState(() {});
                }
              },
            ),
        ],
      ),
    );
  }
}
