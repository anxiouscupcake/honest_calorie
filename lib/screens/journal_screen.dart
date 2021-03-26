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

import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_tracker/main.dart';
import 'package:nutrition_tracker/routes.dart';
import 'package:nutrition_tracker/screens/forms/journal_entry_edit_screen.dart';
import 'package:nutrition_tracker/types/product.dart';
import 'package:nutrition_tracker/types/product_db_screen_arguments.dart';
import 'package:nutrition_tracker/types/journal_entry.dart';
import 'package:nutrition_tracker/types/journal_filter.dart';
import 'package:nutrition_tracker/widgets/drawer.dart';
import 'package:nutrition_tracker/widgets/no_data.dart';
import 'package:nutrition_tracker/localizations.dart';

class JournalScreen extends StatefulWidget {
  static const String routeName = "/journal";
  @override
  JournalScreenState createState() => JournalScreenState();
}

class JournalScreenState extends State<JournalScreen> {
  DateTime _date = new DateTime.now();
  JournalFilter filter;

  _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000, 1),
      lastDate: DateTime(3000),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  _addNewEntry() async {
    final picked = await Navigator.pushNamed(context, Routes.product_db,
        arguments: ProductDBScreenArguments(true));
    if (picked != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => JournalEntryEdit(
                  jentry: new JournalEntry.fromProduct(picked, _date),
                  isEditing: false,
                )),
      );
    }
  }

  Column _buildEntriesFromList(List<JournalEntry> list) {
    return Column(
      children: <Widget>[
        for (JournalEntry entry in list)
          Column(
            children: <Widget>[
              ListTile(
                title: Text(entry.product.name),
                subtitle: Text(entry.getCaloriesString(context)),
                onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => JournalEntryEdit(
                                jentry: entry,
                                isEditing: true,
                              )));
                  setState(() {});
                },
              ),
              Divider(),
            ],
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    filter = new JournalFilter.fromDay(_date);

    TextStyle categoryHeaderStyle = new TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _addNewEntry();
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("journal")),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.date_range),
              onPressed: () {
                _pickDate(context);
              }),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: () {
                      setState(() {
                        _date = _date.add(new Duration(days: -1));
                      });
                    },
                  ),
                ),
                Expanded(
                    child: FlatButton(
                        onPressed: () => _pickDate(context),
                        child: Text(
                          DateFormat.yMMMMd().format(_date),
                          style: new TextStyle(
                            fontSize: 16,
                          ),
                        ))),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: () {
                      setState(() {
                        _date = _date.add(new Duration(days: 1));
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          FutureBuilder(
              future: journal.getEntriesFiltered(filter),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    double totalCalories = 0;
                    List<JournalEntry> breakfast = [];
                    List<JournalEntry> dinner = [];
                    List<JournalEntry> supper = [];
                    List<JournalEntry> other = [];
                    for (int index in snapshot.data) {
                      JournalEntry entry = journal.getEntryByIndex(index);
                      totalCalories += entry.portions * entry.product.calories;
                      switch (entry.category) {
                        case "breakfast":
                          breakfast.add(entry);
                          break;
                        case "dinner":
                          dinner.add(entry);
                          break;
                        case "supper":
                          supper.add(entry);
                          break;
                        case "other":
                          other.add(entry);
                          break;
                        default:
                          debugPrint("ERROR: Uncategorized entry found!");
                          break;
                      }
                    }
                    return Expanded(
                      child: ListView(
                        children: <Widget>[
                          Center(
                              child: Text(
                            totalCalories.toString() +
                                " " +
                                AppLocalizations.of(context)
                                    .translate("out_of") +
                                " " +
                                settings.dailyCalorieGoal.toString() +
                                " " +
                                AppLocalizations.of(context).translate("kcal"),
                            style: new TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                          Divider(),
                          if (breakfast.length > 0)
                            Column(
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context)
                                      .translate("breakfast"),
                                  style: categoryHeaderStyle,
                                ),
                                Divider(),
                                _buildEntriesFromList(breakfast),
                              ],
                            ),
                          if (dinner.length > 0)
                            Column(
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context)
                                      .translate("dinner"),
                                  style: categoryHeaderStyle,
                                ),
                                Divider(),
                                _buildEntriesFromList(dinner),
                              ],
                            ),
                          if (supper.length > 0)
                            Column(
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context)
                                      .translate("supper"),
                                  style: categoryHeaderStyle,
                                ),
                                Divider(),
                                _buildEntriesFromList(supper),
                              ],
                            ),
                          if (other.length > 0)
                            Column(
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context)
                                      .translate("other"),
                                  style: categoryHeaderStyle,
                                ),
                                Divider(),
                                _buildEntriesFromList(other),
                              ],
                            ),
                        ],
                      ),
                    );
                    /*
                    return Column(
                      children: <Widget>[
                        Text(
                          totalCalories.toString() +
                              " " +
                              AppLocalizations.of(context).translate("out_of") +
                              " " +
                              settings.dailyCalorieGoal.toString() +
                              " " +
                              AppLocalizations.of(context).translate("kcal"),
                          style: new TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),*/
                  } else {
                    return NoData(
                      iconData: Icons.book,
                      text:
                          AppLocalizations.of(context).translate("no_entries"),
                    );
                  }
                } else if (snapshot.hasError) {
                  return NoData(
                    iconData: Icons.error,
                    text: AppLocalizations.of(context)
                        .translate("something_went_wrong"),
                  );
                } else {
                  return Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(),
                        width: 60,
                        height: 60,
                      )
                    ],
                  ));
                }
              }),
        ],
      ),
    );
  }
}
