import 'package:flutter/material.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(
          title: const Text('Statistics will be here.'),
        )
      ],
    );
  }
}
