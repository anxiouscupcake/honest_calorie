/* Honest Calorie, an open-source nutrition tracker
Copyright (C) 2024 Roman Zubin

Full notice can be found at /lib/main.dart file. */

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  String username = "You";
  DateTime? dateOfBirth;

  Gender? gender;

  IconData getGenderIconData() {
    if (gender != null) {
      switch (gender) {
        case Gender.female:
          return Icons.female;
        case Gender.male:
          return Icons.male;
        default:
          return Icons.question_mark;
      }
    }
    return Icons.question_mark;
  }

  String getGenderName() {
    if (gender != null) {
      switch (gender) {
        case Gender.female:
          return "Female";
        case Gender.male:
          return "Male";
        default:
          return "Unset";
      }
    }
    return "Unset";
  }

  int calorieGoal = 2000;

  double? weight;
  double? height;

  double? getBMI() {
    if (weight == null || height == null) {
      return null;
    }
    // TODO: implement BMI
    return 0;
  }

  int? getAge() {
    if (dateOfBirth == null) return null;
    // TODO: implement age
    return 0;
  }

  Profile();

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

enum Gender {
  female,
  male,
}
