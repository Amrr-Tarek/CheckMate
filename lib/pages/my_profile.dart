import 'package:flutter/material.dart';
import 'package:checkmate/models/app_bar.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Page Front End - Everything down here is unnecessary
        appBar: appBar(context, "Profile"),
        body: const Center(
            child: Text(
          "My Profile",
          style: TextStyle(fontSize: 26),
        )));
  }
}
