import 'package:flutter/material.dart';

class DayAppBar extends StatelessWidget {
  const DayAppBar({
    super.key,
    required this.selectedDay,
  });

  final DateTime selectedDay;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('data'),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.calendar_today))
      ],
    );
  }
}
