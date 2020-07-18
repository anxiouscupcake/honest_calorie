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
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nutrition_tracker/localizations.dart';
import 'package:nutrition_tracker/main.dart';

class ProfileEdit extends StatefulWidget {
  ProfileEdit({Key key}) : super(key: key);

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: user.birthday == null ? DateTime(2000, 1, 1) : user.birthday,
      firstDate: DateTime(1900, 1),
      lastDate: DateTime(3000),
    );
    if (picked != null && picked != user.birthday) {
      setState(() {
        user.birthday = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context).translate("edit_profile_data")),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              user.save();
              Navigator.pop(context);
            },
          )
        ],
      ),
      // TODO: сделать чтобы при значениях типа 88.0 десятая часть убиралась
      // TODO: сделать валидацию данных
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircleAvatar(
                backgroundImage:
                    NetworkImage("https://i.imgur.com/vM4jpQH.png"),
                maxRadius: 80,
              ),
            ),
          ),
          // TODO: implement image selection
          FlatButton(
            child: Text("Select image"),
            onPressed: () {},
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: TextEditingController(text: user.name),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: "Name",
                    hintText: "What's your name?",
                  ),
                  onChanged: (String value) {
                    user.name = value;
                  },
                ),
                // TODO: implement male/female dropdown
                TextField(
                  controller: TextEditingController(text: user.gender),
                  decoration: const InputDecoration(
                    labelText: "Gender (dropdown will be implemented)",
                  ),
                  onChanged: (String value) {
                    user.gender = value;
                  },
                ),
                // TODO: спрашивать дату рождения, а не возраст
                TextField(
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  controller: TextEditingController(
                    
                      // TODO: localization
                      text: user.birthday == null
                          ? "Tap to select your birth date"
                          : new DateFormat.yMMMMd().format(user.birthday)),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.cake),
                  ),
                  onTap: () {
                    _pickDate(context);
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(
                      text: user.height == 0 ? "" : user.height.toString()),
                  decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: "Height",
                      hintText: "Your height in centimeters"),
                  onChanged: (String value) {
                    user.height = double.tryParse(value);
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(
                      text: user.weight == 0 ? "" : user.weight.toString()),
                  decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: "Weight",
                      hintText: "Your weight in kilograms"),
                  onChanged: (String value) {
                    user.weight = double.tryParse(value);
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
