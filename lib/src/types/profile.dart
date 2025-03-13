/* Honest Calorie, an open-source nutrition tracker
Copyright (C) 2025 Nicole Zubina

Full notice can be found at /lib/main.dart file. */

import 'package:flutter/material.dart';
import 'package:honest_calorie/src/common/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable(includeIfNull: false)
class Profile {
  String username = "You";
  DateTime? dateOfBirth;

  String? gender;

  IconData getGenderIconData() {
    if (gender != null) {
      switch (gender) {
        case GENDER_FEMALE:
          return Icons.female;
        case GENDER_MALE:
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
        case GENDER_FEMALE:
          return "Female";
        case GENDER_MALE:
          return "Male";
        default:
          return "Unset";
      }
    }
    return "Unset";
  }

  int? calorieGoal;

  double? weight;
  double? height;

  double? getBMI() {
    if (weight != null && height != null && height! > 0) {
      return weight! / height!;
    } else {
      return null;
    }
  }

  int? getAge() {
    if (dateOfBirth != null) {
      final diff = DateTime.now().difference(dateOfBirth!);
      return diff.inDays ~/ 365;
    } else {
      return null;
    }
  }

  Profile();

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
