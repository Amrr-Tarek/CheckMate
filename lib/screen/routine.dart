import 'package:flutter/material.dart';
import 'package:checkmate/const/colors.dart';

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
        appBar: AppBar(
          backgroundColor: AppColors.boxColor,
          title: const Text("CheckMate",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: const Center(
            child: Text(
          "Routine",
          style: TextStyle(fontSize: 26),
        )));
  }
}
