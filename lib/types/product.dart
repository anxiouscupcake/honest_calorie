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

import 'package:flutter/cupertino.dart';
import 'package:nutrition_tracker/localizations.dart';

class Product {
  Product();

  // basic information
  /// Index of product in database.
  String name = "";
  String code = "";
  String category = "";
  int calories = 0; // kcal
  int servingSize = 100;
  String servingUnit = "grams"; // grams, ml, portion
  String getLocalizedUnit(BuildContext context) {
    switch (this.servingUnit) {
      case "grams":
        return AppLocalizations.of(context).translate("grams");
      case "ml":
        return AppLocalizations.of(context).translate("ml");
      case "portion":
        return AppLocalizations.of(context).translate("portion");
      default:
        return "ERROR: no such unit: " + this.servingUnit;
    }
  }

  // additional information
  String notes = "";
  double protein = 0;
  double fat = 0;
  double saturatedFat = 0;
  double carbohydrates = 0;
  double sugar = 0;
  double salt = 0;
  int sodium = 0; // in mg
  double fibre = 0;

  Product.fromJson(Map<String, dynamic> json) {
    // basic information
    name = json["name"];
    code = json["code"];
    category = json["category"];
    calories = json["calories"];
    servingSize = json["servingSize"];
    servingUnit = json["servingUnit"];
    // additional information
    if (json["notes"] != null)
      notes = json["notes"];
    else
      notes = "";
    if (json["protein"] != null)
      protein = json["protein"];
    else
      protein = 0;
    if (json["fat"] != null)
      fat = json["fat"];
    else
      fat = 0;
    if (json["saturatedFat"] != null)
      saturatedFat = json["saturatedFat"];
    else
      saturatedFat = 0;
    if (json["carbohydrates"] != null)
      carbohydrates = json["carbohydrates"];
    else
      carbohydrates = 0;
    if (json["sugar"] != null)
      sugar = json["sugar"];
    else
      sugar = 0;
    if (json["salt"] != null)
      salt = json["salt"];
    else
      salt = 0;
    if (json["sodium"] != null)
      sodium = json["sodium"];
    else
      sodium = 0;
    if (json["fibre"] != null)
      fibre = json["fibre"];
    else
      fibre = 0;
  }

  Map<String, dynamic> toJson() => {
        // basic information
        "name": name,
        "category": category,
        "calories": calories,
        "servingSize": servingSize,
        "servingUnit": servingUnit,
        // additional information
        if (notes != "")
          "notes": notes,
        if (protein != 0)
          "protein": protein,
        if (fat != 0)
          "fat": fat,
        if (saturatedFat != 0)
          "saturatedFat": saturatedFat,
        if (carbohydrates != 0)
          "carbohydrates": carbohydrates,
        if (sugar != 0)
          "sugar": sugar,
        if (salt != 0)
          "salt": salt,
        if (sodium != 0)
          "sodium": sodium,
        if (fibre != 0)
          "fibre": fibre,
      };
}
