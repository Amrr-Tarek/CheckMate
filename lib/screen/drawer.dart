import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 70,
            decoration: BoxDecoration(
              // Logo
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: AssetImage('lib/assets/app_icon.jpg'),
              ),
            ),
          ),
          Text("Your Name!"),
        ],
      ),
    );
  }
}

Widget myDrawerList() {
  return Container(
    padding: const EdgeInsets.only(top: 10, bottom: 10),
    child: Column(
      // Drawer's Menu
      // Create a class and add instances to the menu with the following parameters
      /// String title
      /// String iconPath / IconData icon
      /// an instance of the page you are trying to navigate to
      /// bool selected
    ),
  );
}

// Drawer myDrawer(BuildContext context) {
//   return Drawer(
//     child: ListView(
//       children: [
//         ListTile(
//           title: const Text("Calendar"),
//           onTap: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => const Calendar()));
//           },
//         ),
//         ListTile(
//             title: const Text("Goals"),
//             onTap: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => const Goals()));
//             }),
//         ListTile(
//             title: const Text("Routine"),
//             onTap: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => const Routine()));
//             }),
//         ListTile(
//           title: const Text("My Profile"),
//           onTap: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => const MyProfile()));
//           },
//         ),
//         ListTile(
//             title: const Text("Settings"),
//             onTap: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => const Settings()));
//             }),

//         /// Create a class for the ListTiles.. add the following as attributes:
//         /// title
//         /// iconPath
//         /// an instance of the page you are trying to navigate to
//       ],
//     ),
//   );
// }
