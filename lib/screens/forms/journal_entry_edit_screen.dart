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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:nutrition_tracker/localizations.dart';
import 'package:nutrition_tracker/main.dart';
import 'package:nutrition_tracker/routes.dart';
import 'package:nutrition_tracker/types/product.dart';
import 'package:nutrition_tracker/types/product_db_screen_arguments.dart';
import 'package:nutrition_tracker/types/journal_entry.dart';

import 'package:nutrition_tracker/types/exceptions/index_is_null.dart';
import 'package:nutrition_tracker/widgets/category_selector.dart';

class JournalEntryEdit extends StatefulWidget {
  final JournalEntry jentry;
  //final DateTime dateTime;
  final bool isEditing;
  //final int index;

  const JournalEntryEdit({
    Key key,
    @required this.jentry,
    //this.dateTime,
    @required this.isEditing,
    //this.index,
  }) : super(key: key);

  @override
  _JournalEntryEditState createState() => _JournalEntryEditState();
}

class _JournalEntryEditState extends State<JournalEntryEdit> {
  _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.jentry.dateTime,
      firstDate: DateTime(2000, 1),
      lastDate: DateTime(3000),
    );
    if (picked != null && picked != widget.jentry.dateTime) {
      setState(() {
        widget.jentry.dateTime = picked;
      });
    }
  }

  _pickProduct(BuildContext context) async {
    final picked = await Navigator.pushNamed(context, Routes.product_db,
        arguments: ProductDBScreenArguments(true));
    if (picked != null) {
      setState(() {
        widget.jentry.product = picked;
      });
    }
  }

  _pickCategory(BuildContext context) async {
    List<String> categoryKeys = ["breakfast", "dinner", "supper", "other"];
    final picked = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CategorySelector(
                titleKey: "pick_category",
                categoryKeys: categoryKeys,
              )),
    );
    if (picked != null) {
      widget.jentry.category = picked;
      lastCategory = picked;
      setState(() {});
    }
  }

  /*
  String _getCaloriesString(JournalEntry entry) {
    return (entry.product.calories * entry.portions).toString() +
        " " +
        AppLocalizations.of(context).translate("kcal_per") +
        " " +
        (entry.product.servingSize * entry.portions).toString() +
        " " +
        entry.product.getLocalizedUnit(context);
  }
  */

  @override
  Widget build(BuildContext context) {
    /*
    if (widget.isEditing && widget.index == null) {
      throw new IndexIsNull();
    }
    */

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing
            ? AppLocalizations.of(context).translate("edit_entry")
            : AppLocalizations.of(context).translate("new_entry")),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          if (widget.isEditing)
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // TODO: confirmation
                  journal.removeEntry(widget.jentry);
                  Navigator.pop(context);
                }),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (widget.isEditing) {
                journal.saveDatabase();
              } else {
                journal.addEntry(widget.jentry);
              }
              Navigator.pop(context);
            },
          )
        ],
      ),
      // TODO: сделать покрасивее и попонятнее
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: <Widget>[
                TextField(
                  readOnly: true,
                  controller:
                      TextEditingController(text: widget.jentry.product.name),
                  decoration: InputDecoration(
                    icon: Icon(Icons.fastfood),
                    labelText: AppLocalizations.of(context)
                        .translate("select_product"),
                  ),
                  onTap: () {
                    _pickProduct(context);
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(
                      text: widget.jentry.portions.toString()),
                  decoration: InputDecoration(
                    icon: Icon(Icons.fastfood),
                    labelText:
                        AppLocalizations.of(context).translate("portions"),
                    hintText:
                        AppLocalizations.of(context).translate("portions_hint"),
                    helperText: widget.jentry.getCaloriesString(context),
                  ),
                  onChanged: (value) {
                    widget.jentry.portions = double.tryParse(value);
                    setState(() {});
                  },
                ),
                TextField(
                  readOnly: true,
                  controller: TextEditingController(
                      text: widget.jentry.getLocalizedCategory(context)),
                  decoration: InputDecoration(
                      icon: Icon(Icons.category),
                      labelText: AppLocalizations.of(context)
                          .translate("select_category")),
                  onTap: () {
                    _pickCategory(context);
                  },
                ),
                TextField(
                  readOnly: true,
                  controller: TextEditingController(
                    text:
                        new DateFormat.yMMMMd().format(widget.jentry.dateTime),
                  ),
                  decoration: InputDecoration(
                    icon: Icon(Icons.date_range),
                    labelText: AppLocalizations.of(context)
                        .translate("tap_select_date"),
                  ),
                  onTap: () {
                    _pickDate(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
