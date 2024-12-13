import 'package:flutter/material.dart';
import 'package:checkmate/models/app_bar.dart';

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
        appBar: appBar("Settings"),
        body: const Center(
            child: Text(
          "Settings",
          style: TextStyle(fontSize: 26),
        )));
  }
}
