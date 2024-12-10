import 'package:flutter/material.dart';
import 'package:checkmate/const/colors.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
              color: AppColors.backgroundColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: const Center(
            child: Text(
          "Settings",
          style: TextStyle(fontSize: 26),
        )));
  }
}
