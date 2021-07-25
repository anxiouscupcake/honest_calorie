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

import 'package:flutter/material.dart';
import 'package:honest_calorie/routes.dart';
import 'package:honest_calorie/widgets/drawer.dart';

import 'package:honest_calorie/main.dart';
import 'package:honest_calorie/widgets/no_data.dart';

class StatisticsScreen extends StatefulWidget {
  static const String routeName = "/statistics";

  @override
  State createState() => new StatisticsScreenState();
}

class StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text("Statistics"),
        ),
        body: ListView(
          children: <Widget>[
            // TODO: implement statistics
            NoData(
              iconData: Icons.error,
              text: "Not implemented yet",
            ),
          ],
        ));
  }
}
