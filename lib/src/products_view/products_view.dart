import 'package:flutter/material.dart';
import 'package:honest_calorie/src/bottom_bar.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  static const routeName = '/products';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
