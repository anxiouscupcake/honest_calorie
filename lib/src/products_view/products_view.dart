import 'package:flutter/material.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

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
