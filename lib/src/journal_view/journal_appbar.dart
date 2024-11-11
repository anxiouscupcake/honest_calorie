import 'package:flutter/material.dart';
import 'package:honest_calorie/src/extensions/date_time_extension.dart';

class JournalAppBar extends StatelessWidget {
  const JournalAppBar({
    super.key,
    required this.selectedDay,
  });

  final DateTime selectedDay;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(selectedDay.toReadableDay()),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.calendar_today))
      ],
    );
  }
}
