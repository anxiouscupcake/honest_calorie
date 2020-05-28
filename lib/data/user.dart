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

import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class User {
  User();

  String name = "";
  String gender = "";
  int age = 0;
  double weight = 0.0; // kg
  double height = 0.0; // cm

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        gender = json['gender'],
        age = json['age'],
        height = json['height'],
        weight = json['weight'];

  Map<String, dynamic> toJson() => {
        "name": name,
        "gender": gender,
        "age": age,
        "height": height,
        "weight": weight,
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
      Map map = jsonDecode(content);
      User u = User.fromJson(map);
      this.name = u.name;
      this.gender = u.gender;
      this.age = u.age;
      this.weight = u.weight;
      this.height = u.height;
      return true;
    } catch (e) {
      debugPrint("Failed to read user data file. Creating empty one...");
      save();
      return false;
    }
  }

  Future<File> save() async {
    final file = await _localFile;
    return file.writeAsString(json.encode(this));
  }

  double getBMI() {
    if (weight == 0 || height == 0)
      return 0;
    else
      return weight / ((height / 100.0) * (height / 100.0));
  }
}
