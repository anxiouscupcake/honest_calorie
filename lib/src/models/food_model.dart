/* Honest Calorie, an open-source nutrition tracker
Copyright (C) 2024 Roman Zubin

Full notice can be found at /lib/main.dart file. */

import 'package:honest_calorie/src/types/food.dart';

class FoodModel {
  late List<Food> _presetFoods;

  FoodModel() {
    // debug list for testing
    _presetFoods = List.empty(growable: true);

    Food apple = Food.fromNameCalories("Apple", 72);
    apple.protein = 0.36;
    apple.fat = 0.23;
    apple.totalCarbs = 19.06;
    apple.sugars = 14.34;
    apple.fiber = 3.3;
    _presetFoods.add(apple);

    Food egg = Food.fromNameCalories("Egg", 74);
    egg.protein = 6.29;
    egg.fat = 4.97;
    egg.totalCarbs = 0.38;
    egg.sugars = 0.38;
    egg.fiber = 0;
    _presetFoods.add(egg);
  }

  Future<List<Food>> getPresetFoods() async {
    // TODO: parse preset foods from JSON file
    return _presetFoods;
  }
}
