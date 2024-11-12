/* Honest Calorie, an open-source nutrition tracker
Copyright (C) 2024 Roman Zubin

Full notice can be found at /lib/main.dart file. */

import 'package:flutter/material.dart';

// Design
const defaultCircularRadius = Radius.circular(12);
const defaultRoundedRectangleTop = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
      topLeft: defaultCircularRadius, topRight: defaultCircularRadius),
);

// Shadows
const subtleShadow =
    BoxShadow(color: Colors.black12, offset: Offset(0, 0), blurRadius: 5);
