/* Honest Calorie, an open-source nutrition tracker
Copyright (C) 2024 Roman Zubin

Full notice can be found at /lib/main.dart file. */

import 'package:flutter/material.dart';

class FoodView extends StatelessWidget {
  const FoodView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(
          title: const Text('data'),
        ),
        ListTile(
          title: const Text('data'),
        ),
        ListTile(
          title: const Text('data'),
        ),
        ListTile(
          title: const Text('data'),
        )
      ],
    );
  }
}
