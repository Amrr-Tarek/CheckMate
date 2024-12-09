import 'package:flutter/material.dart';
import 'package:checkmate/const/colors.dart';

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
        appBar: AppBar(
          backgroundColor: AppColors().boxColor,
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
          "My Profile",
          style: TextStyle(fontSize: 26),
        )));
  }
}
