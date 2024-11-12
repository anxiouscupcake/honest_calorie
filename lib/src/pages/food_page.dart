/* Honest Calorie, an open-source nutrition tracker
Copyright (C) 2024 Roman Zubin

Full notice can be found at /lib/main.dart file. */

import 'package:flutter/material.dart';

class FoodPage extends StatelessWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(
          title: Text('data'),
        ),
        ListTile(
          title: Text('data'),
        ),
        ListTile(
          title: Text('data'),
        ),
        ListTile(
          title: Text('data'),
        )
      ],
    );
  }
}
