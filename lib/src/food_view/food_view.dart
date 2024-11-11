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
