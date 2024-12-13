import 'package:checkmate/models/drawer.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/models/app_bar.dart';

class Routine extends StatefulWidget {
  const Routine({super.key});

  @override
  State<Routine> createState() => _RoutineState();
}

class _RoutineState extends State<Routine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Page Front End - Everything down here is unnecessary
        appBar: appBar(context, "Routine"),
        drawer: MyDrawer.createDrawer(context, "routine"),
        body: const Center(
            child: Text(
          "Routine",
          style: TextStyle(fontSize: 26),
        )));
  }
}
