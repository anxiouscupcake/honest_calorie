import 'package:flutter/material.dart';
import 'package:honest_calorie/src/bottom_bar.dart';

class DayView extends StatelessWidget {
  const DayView({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
      ),
      bottomNavigationBar: BottomBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
