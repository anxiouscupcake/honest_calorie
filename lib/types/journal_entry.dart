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

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:honest_calorie/localizations.dart';
import 'package:honest_calorie/types/product.dart';

String lastCategory = "breakfast";

class JournalEntry {
  JournalEntry.fromProduct(this.product, this.dateTime);

  Product product = new Product();

  double portions = 1;
  String getCaloriesString(BuildContext context) {
    return (this.product.calories * this.portions).toString() +
        " " +
        AppLocalizations.of(context).translate("kcal_per") +
        " " +
        (this.product.servingSize * this.portions).toString() +
        " " +
        this.product.getLocalizedUnit(context);
  }

  /// Possible values: breakfast, dinner, supper, other
  String category = lastCategory;
  String getLocalizedCategory(BuildContext context) {
    switch (this.category) {
      case "breakfast":
        return AppLocalizations.of(context).translate("breakfast");
      case "dinner":
        return AppLocalizations.of(context).translate("dinner");
      case "supper":
        return AppLocalizations.of(context).translate("supper");
      case "other":
        return AppLocalizations.of(context).translate("other");
      default:
        return "ERROR: no such category: " + this.category;
    }
  }

  DateTime dateTime = DateTime.now();

  JournalEntry.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> map = jsonDecode(json["product"].toString());
    product = new Product.fromJson(map);
    portions = json["portions"];
    category = json["category"];
    String dateString = json["date"];
    dateTime = DateTime.parse(dateString);
  }

  Map<String, dynamic> toJson() => {
        "product": jsonEncode(product),
        "portions": portions,
        "category": category,
        "date": dateTime.toIso8601String(),
      };
}
