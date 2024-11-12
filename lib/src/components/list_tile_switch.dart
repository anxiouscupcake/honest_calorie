/* Honest Calorie, an open-source nutrition tracker
Copyright (C) 2024 Roman Zubin

Full notice can be found at /lib/main.dart file. */

import 'package:flutter/material.dart';

class ListTileSwitch extends StatefulWidget {
  const ListTileSwitch({
    super.key,
    required this.value,
    required this.valueSetter,
    this.title,
    this.subtitle,
  });

  final bool value;
  final ValueSetter<bool> valueSetter;

  final Widget? title;
  final Widget? subtitle;

  @override
  State<StatefulWidget> createState() => _ListTileSwichState();
}

class _ListTileSwichState extends State<ListTileSwitch> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: widget.title,
      subtitle: widget.subtitle,
      trailing: Switch(
        onChanged: (value) {
          setState(() {
            widget.valueSetter(value);
          });
        },
        value: widget.value,
      ),
    );
  }
}
