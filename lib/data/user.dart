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

import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class User {
  User();

  String name = "User";
  String? gender;
  DateTime? birthday;
  double? weight; // kg
  double? height; // cm

  String? getSummaryData() {
    String summary = "";

    if (weight != null && height != null) {
      if (weight! > 0) {
        summary += weight.toString() + " kg";
        if (height! > 0 && getBMI() != null) {
          summary += ", BMI: " + getBMI()!.toStringAsFixed(1);
        }
      }
      return summary;
    } else {
      return null;
    }
  }

  double? getBMI() {
    if (weight != null && height != null) {
      if (weight! == 0 || height! == 0)
        return null;
      else
        return weight! / ((height! / 100.0) * (height! / 100.0));
    } else {
      return null;
    }
  }

  User.fromJson(Map<String, dynamic> json) {
    if (json['name'] != null) name = json['name'];
    if (json['gender'] != null) gender = json['gender'];
    if (json['height'] != null) height = json['height'];
    if (json['weight'] != null) weight = json['weight'];

    if (json["birthday"] != null) {
      String dateString = json["birthday"];
      birthday = DateTime.parse(dateString);
    }
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        if (gender != null) "gender": gender,
        if (height != null) "height": height,
        if (weight != null) "weight": weight,
        if (birthday != null) "birthday": birthday!.toIso8601String(),
      };

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File(path + "/user.json");
  }

  Future<bool> load() async {
    try {
      final file = await _localFile;
      String content = await file.readAsString();
      Map<String, dynamic> map = jsonDecode(content);
      User u = User.fromJson(map);
      this.name = u.name;
      this.gender = u.gender;
      this.birthday = u.birthday;
      this.weight = u.weight;
      this.height = u.height;
      debugPrint("User data is loaded");
      return true;
    } catch (e) {
      debugPrint("Failed to read user data file. Creating empty one...");
      save();
      return false;
    }
  }

  Future<File> save() async {
    final file = await _localFile;
    debugPrint("JSON: " + json.encode(this));
    return file.writeAsString(json.encode(this));
  }
}
