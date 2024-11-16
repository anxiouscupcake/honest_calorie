/* Honest Calorie, an open-source nutrition tracker
Copyright (C) 2024 Roman Zubin

Full notice can be found at /lib/main.dart file. */

import 'package:json_annotation/json_annotation.dart';

part 'food.g.dart';

@JsonSerializable(includeIfNull: false)
class Food {
  Food();
  Food.fromNameCalories(this.name, this.calories);

  String name = "Unnamed food";
  int calories = 0;

  double? protein;

  double? fat;

  /// Includes sugar.
  double? totalCarbs;
  double? sugars;

  double? fiber;

  String getTextCalorieSummary() {
    return '${calories.toString()} kcal per 100 grams';
  }

  static Food getRandomFood() {
    Food food = Food();
    return food;
  }

  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);
  Map<String, dynamic> toJson() => _$FoodToJson(this);
}
