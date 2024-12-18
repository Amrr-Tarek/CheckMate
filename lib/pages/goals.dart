import 'package:checkmate/models/drawer.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/models/app_bar.dart';

class Event {
  final String title;
  Event({required this.title});
}

class Goals extends StatefulWidget {
  const Goals({super.key});

  @override
  State<Goals> createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Page Front End - Everything down here is unnecessary
        appBar: appBar(context, "Goals"),
        drawer: MyDrawer.createDrawer(context, "goals"),
        body: const Center(
            child: Text(
          "Goals",
          style: TextStyle(fontSize: 26),
        )));
  }
}
