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
import 'package:honest_calorie/localizations.dart';

class Product {
  Product();

  // required information
  String name = "";
  String? code;
  String? category;
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
  String? notes;
  double? protein;
  double? fat;
  double? saturatedFat;
  double? carbohydrates;
  double? sugar;
  double? salt;
  int? sodium; // in mg
  double? fibre;

  Product.fromJson(Map<String, dynamic> json) {
    // required information
    name = json["name"];
    calories = json["calories"];
    servingSize = json["servingSize"];
    servingUnit = json["servingUnit"];

    // additional information
    if (json['category'] != null) category = json["category"];
    if (json['code'] != null) code = json["code"];
    if (json["notes"] != null) notes = json["notes"];
    if (json["protein"] != null) protein = json["protein"];
    if (json["fat"] != null) fat = json["fat"];
    if (json["saturatedFat"] != null) saturatedFat = json["saturatedFat"];
    if (json["carbohydrates"] != null) carbohydrates = json["carbohydrates"];
    if (json["sugar"] != null) sugar = json["sugar"];
    if (json["salt"] != null) salt = json["salt"];
    if (json["sodium"] != null) sodium = json["sodium"];
    if (json["fibre"] != null) fibre = json["fibre"];
  }

  Map<String, dynamic> toJson() => {
        // required information
        "name": name,
        "calories": calories,
        "servingSize": servingSize,
        "servingUnit": servingUnit,

        // additional information
        if (category != null) "category": category,
        if (code != null) "code": code,
        if (notes != null) "notes": notes,
        if (protein != null) "protein": protein,
        if (fat != null) "fat": fat,
        if (saturatedFat != null) "saturatedFat": saturatedFat,
        if (carbohydrates != null) "carbohydrates": carbohydrates,
        if (sugar != null) "sugar": sugar,
        if (salt != null) "salt": salt,
        if (sodium != null) "sodium": sodium,
        if (fibre != null) "fibre": fibre,
      };
}
