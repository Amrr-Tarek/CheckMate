import 'package:flutter/material.dart';
import 'package:checkmate/models/buttons.dart';
import 'package:checkmate/models/app_bar.dart';
import 'package:checkmate/models/navigator.dart';
import 'package:checkmate/models/drawer.dart';

class HomePage extends StatefulWidget {
  final String title = "Home";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // add sth

  @override
  Widget build(BuildContext context) {
    // Is ran everytime setState is called
    return Scaffold(
      appBar: appBar("Dashboard"),
      drawer: createDrawer(context, "dashboard"),
      body: __body(),
    );
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
                navigate(context, '/calendar');
              }),
          Button(
              text: "Routine",
              onPress: () {
                navigate(context, '/routine');
              }),
          Button(
              text: "Goals",
              onPress: () {
                navigate(context, '/goals');
              }),
          Button(
              text: "My Profile",
              onPress: () {
                navigate(context, '/myprofile');
              }),
          Button(
              text: "Settings",
              onPress: () {
                navigate(context, "/settings");
              }),
        ],
      )),
    );
  }
}
