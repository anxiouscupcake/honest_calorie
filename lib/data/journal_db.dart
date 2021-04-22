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
import 'package:honest_calorie/extensions/datetime.dart';
import 'package:honest_calorie/types/journal_entry.dart';
import 'package:honest_calorie/types/journal_filter.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class JournalDatabase {
  JournalDatabase();

  late List<JournalEntry> _jlist;

  int entryCount() {
    return _jlist.length;
  }

  Future<List<int>> getEntriesFiltered(JournalFilter filter) async {
    List<int> list = [];
    for (int i = 0; i < _jlist.length; i++) {
      if (_jlist[i].dateTime.isSameDate(filter.dateFrom!)) {
        list.add(i);
      }
    }
    return list;
  }

  JournalEntry getEntryByIndex(int index) {
    return _jlist[index];
  }

  /// Adds given product item to database.
  Future<bool> _addEntry(JournalEntry entry) async {
    _jlist.add(entry);
    save();
    return true;
  }

  Future<bool> addEntry(JournalEntry entry) async {
    bool b = await _addEntry(entry);
    if (b) save();
    debugPrint("JSON: " + jsonEncode(entry));
    return b;
  }

  removeEntry(JournalEntry entry) {
    _jlist.remove(entry);
    save();
  }

  replaceWith(JournalEntry entry, int index) {
    _jlist[index] = entry;
    save();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File(path + "/journal-db.json");
  }

  Future<bool> load() async {
    Stopwatch stopwatch = new Stopwatch();
    stopwatch.start();
    try {
      //await Future.delayed(const Duration(seconds: 3), () {});
      _jlist = [];
      final file = await _localFile;
      List<dynamic> d = await json.decode(file.readAsStringSync());
      _jlist = d.map<JournalEntry>((f) => JournalEntry.fromJson(f)).toList();
      stopwatch.stop();
      debugPrint("DEBUG: Journal loaded in " +
          stopwatch.elapsedMilliseconds.toString() +
          "ms");
      return true;
    } catch (e) {
      debugPrint("Caught exception: " + e.toString());
      debugPrint("Failed to read journal file. Creating default one...");
      await save();
      stopwatch.stop();
      return false;
    }
  }

  /// Writes database to file.
  Future<File> save() async {
    Stopwatch stopwatch = new Stopwatch();
    stopwatch.start();
    final file = await _localFile;
    Future<File> f = file.writeAsString(jsonEncode(_jlist));
    stopwatch.stop();
    debugPrint("DEBUG: Product database written in " +
        stopwatch.elapsedMilliseconds.toString() +
        "ms");
    return f;
  }
}
