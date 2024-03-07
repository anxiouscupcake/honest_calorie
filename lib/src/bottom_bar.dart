import 'package:flutter/material.dart';
import 'package:honest_calorie/src/day_view/day_view.dart';
import 'package:honest_calorie/src/products_view/products_view.dart';
import 'package:honest_calorie/src/settings/settings_view.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                if (ModalRoute.of(context)!.settings.name !=
                    DayView.routeName) {
                  Navigator.pushReplacementNamed(context, DayView.routeName);
                }
              },
              icon: const Icon(Icons.home_filled)),
          IconButton(
              onPressed: () {
                if (ModalRoute.of(context)!.settings.name !=
                    ProductsView.routeName) {
                  Navigator.pushReplacementNamed(
                      context, ProductsView.routeName);
                }
              },
              icon: const Icon(Icons.view_list_rounded)),
          IconButton(
              onPressed: () {
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
              icon: const Icon(Icons.settings))
        ],
      ),
    );
  }
}
