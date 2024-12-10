import 'package:flutter/material.dart';
import 'package:checkmate/const/buttons.dart';
import 'package:checkmate/screen/calendar.dart';
import 'package:checkmate/screen/routine.dart';
import 'package:checkmate/screen/goals.dart';
import 'package:checkmate/screen/my_profile.dart';
import 'package:checkmate/screen/settings.dart';
import 'package:checkmate/const/colors.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // add sth

  @override
  Widget build(BuildContext context) {
    // Is ran everytime setState is called
    return Scaffold(
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
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Hello :)\nThis Page is 'Getting Started' for you to implement the front end of the pages listed in the buttons below\nPress on the button to take you to the page (crazy right?!)\nادعيلي (معرفش ليه بس عشان اخوك محتاج الدعوة)",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Button(
                label: "Calendar",
                backgroundColor: AppColors.boxColor,
                onPressed: () {
                  // Push Calendar Page to the Navigator
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Calendar()));
                }),
            const SizedBox(height: 20),
            Button(
                label: "Routine",
                backgroundColor: AppColors.boxColor,
                onPressed: () {
                  // Push Routine Page to the Navigator
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Routine()));
                }),
            const SizedBox(height: 20),
            Button(
                label: "Goals",
                backgroundColor: AppColors.boxColor,
                onPressed: () {
                  // Push Goals Page to the Navigator
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Goals()));
                }),
            const SizedBox(height: 20),
            Button(
                label: "My Profile",
                backgroundColor: AppColors.boxColor,
                onPressed: () {
                  // Push My Profile to the Navigator
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyProfile()));
                }),
            const SizedBox(height: 20), // I don't like the look of this neither
            Button(
                label: "Settings",
                backgroundColor: AppColors.boxColor,
                onPressed: () {
                  // Push Settings Page to the Navigator
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Settings()));
                }),
          ],
        )));
  }
}
