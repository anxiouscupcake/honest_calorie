/* Honest Calorie, an open-source nutrition tracker
Copyright (C) 2025 Nicole Zubina

Full notice can be found at /lib/main.dart file. */

import 'package:flutter/material.dart';
import 'package:honest_calorie/src/models/food_model.dart';
import 'package:honest_calorie/src/types/food.dart';
import 'package:provider/provider.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<StatefulWidget> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  late FoodModel foodModel;

  static const double filtersHeight = 80;

  Future<List<Food>> getFoods() async {
    return await foodModel.getPresetFoods();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    foodModel = Provider.of<FoodModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder(
          future: getFoods(),
          builder: (context, snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              List<Food> foods = snapshot.data!;
              if (foods.isEmpty) {
                children = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.black38,
                    size: 120,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('Nothing found'),
                  ),
                ];
              } else {
                children = [
                  const SizedBox(
                    height: filtersHeight,
                  )
                ];
                for (var food in foods) {
                  children.add(ListTile(
                    title: Text(food.name),
                    subtitle: Text(food.getTextCalorieSummary()),
                  ));
                }
              }
            } else if (snapshot.hasError) {
              children = <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 120,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                ),
              ];
            } else {
              children = const <Widget>[
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(),
                ),
              ];
            }
            return ListView(
              children: children,
            );
          },
        ),
        Container(
          height: filtersHeight,
          color: Colors.amber,
        ),
      ],
    );
  }
}
