import 'package:flutter/material.dart';
import 'package:checkmate/const/buttons.dart';
import 'package:checkmate/screen/calendar.dart';
import 'package:checkmate/screen/routine.dart';
import 'package:checkmate/screen/goals.dart';
import 'package:checkmate/screen/my_profile.dart';
import 'package:checkmate/screen/settings.dart';
import 'package:checkmate/screen/drawer.dart';

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
      appBar: appBar(),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                MyDrawer(),
                myDrawerList(),
              ],
            ),
          ),
        ),
      ),
      body: __body(),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: const Color(0xFFB9A3F4),
      title: const Text("Dashboard",
          style: TextStyle(
              color: Color(0xFF1D1B20),
              fontSize: 22,
              fontWeight: FontWeight.bold) // Change to Cairo
          ),
      centerTitle: true,
      // leading: IconButton(
      //   icon: const Icon(
      //     Icons.menu,
      //     color: Color(0xFF1D1B20),
      //   ),
      //   onPressed: () {
      //     // Display Drawer
      //   },
      // ),
    ); // Remember to add a suffix for the profile
  }

  Container __body() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Hello :)\nThis Page is 'Getting Started' for you to implement the front end of the pages listed in the buttons below\nPress on the button to take you to the page (crazy right?!)\nادعيلي (معرفش ليه بس اخوك محتاج الدعوة)",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Button(
              text: "Calendar",
              onPress: () {
                // Push Calendar Page to the Navigator
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Calendar()));
              }),
          Button(
              text: "Routine",
              onPress: () {
                // Push Routine Page to the Navigator
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Routine()));
              }),
          Button(
              text: "Goals",
              onPress: () {
                // Push Goals Page to the Navigator
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Goals()));
              }),
          Button(
              text: "My Profile",
              onPress: () {
                // Push My Profile to the Navigator
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyProfile()));
              }),
          Button(
              text: "Settings",
              onPress: () {
                // Push Settings Page to the Navigator
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Settings()));
              }),
        ],
      )),
    );
  }
}
