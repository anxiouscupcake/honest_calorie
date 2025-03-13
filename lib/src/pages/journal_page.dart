/* Honest Calorie, an open-source nutrition tracker
Copyright (C) 2025 Nicole Zubina

Full notice can be found at /lib/main.dart file. */

import 'package:flutter/material.dart';
import 'package:honest_calorie/src/models/journal_model.dart';
import 'package:provider/provider.dart';

class JournalView extends StatefulWidget {
  const JournalView({super.key});

  @override
  State<StatefulWidget> createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView> {
  late JournalModel journalModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    journalModel = Provider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Text(journalModel.selectedDate.toIso8601String());
  }
}
