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

class Settings {
  Settings();

  int dailyCalorieGoal = 2000;

  bool waterTracking = false;
  bool showFeedback = true;

  // TODO: значение должны браться в зависимости от локали
  List<String> mealCategories = [
    "Breakfast",
    "Dinner",
    "Supper",
    "Other"
  ];

  // TODO: make default value false
  bool debugging = true;

  Settings.fromJson(Map<String, dynamic> json) {
    debugging = json["debugging"];
    dailyCalorieGoal = json["dailyCalorieGoal"];
    waterTracking = json["waterTracking"];
    showFeedback = json["showFeedback"];
  }

  Map<String, dynamic> toJson() => {
        "debugging": debugging,
        "dailyCalorieGoal": dailyCalorieGoal,
        "waterTracking": waterTracking,
        "showFeedback": showFeedback,
      };

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File(path + "/settings.json");
  }

  Future<bool> load() async {
    try {
      final file = await _localFile;
      String content = await file.readAsString();
      Map<String, dynamic> map = jsonDecode(content);
      Settings settings = Settings.fromJson(map);
      this.debugging = settings.debugging;
      this.waterTracking = settings.waterTracking;
      this.showFeedback = settings.showFeedback;
      debugPrint("Settings are loaded");
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
}
