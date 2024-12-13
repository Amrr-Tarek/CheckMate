import 'package:checkmate/models/navigator.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();

  static Drawer createDrawer(BuildContext context, String selected) {
  return Drawer(
    child: SingleChildScrollView(
      child: Column(
        children: [
          const MyDrawer(),
          myDrawerList(context, selected),
        ],
      ),
    ),
  );
}

}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(179, 153, 241, 0.3),
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 70,
            decoration: const BoxDecoration(
              // Logo
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/app_icon.png'),
              ),
            ),
          ),
          const Text("Your Name!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class DrawerMenuButtons extends StatelessWidget {
  /// A class that handles the initialization of each button in the drawer
  final String title;
  final IconData icon;
  final String page; // The page to be navigated to upon press
  final bool selected; // If there should be a visual aid for selection

  const DrawerMenuButtons({
    super.key,
    required this.title,
    required this.icon,
    required this.page,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? const Color.fromARGB(133, 186, 140, 230)
              : const Color.fromARGB(50, 182, 129, 232),
          borderRadius: BorderRadius.circular(30),
        ),
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            navigate(context, page);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: Row(
              children: [
                Expanded(
                  child: Icon(
                    icon,
                    size: 22,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )), // Add text style
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget myDrawerList(BuildContext context, String? selected) {
  return Container(
    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
    child: Column(
      children: [
        DrawerMenuButtons(
          title: "Dashboard",
          icon: Icons.dashboard,
          page: '/home',
          selected: selected == "dashboard",
        ),
        DrawerMenuButtons(
          title: "Calendar",
          icon: Icons.calendar_month,
          page: '/calendar',
          selected: selected == "calendar",
        ),
        DrawerMenuButtons(
          title: "Routine",
          icon: Icons.repeat,
          page: '/routine',
          selected: selected == "routine",
        ),
        DrawerMenuButtons(
          title: "Goals",
          icon: Icons.album_outlined,
          page: '/goals',
          selected: selected == "goals",
        ),
        DrawerMenuButtons(
          title: "Settings",
          icon: Icons.settings,
          page: '/settings',
          selected: selected == "settings",
        ),
        const Divider(),
        InkWell(
            onTap: () {
              navigate(context, '/myprofile');
            },
            child: Container(
              margin: const EdgeInsets.only(right: 20, left: 20, top: 5),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Expanded(
                      child: Text(
                    "Your Name",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  )),
                  Container(
                      // Outline
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color.fromARGB(209, 77, 48, 243),
                              width: 3)),
                      padding: const EdgeInsets.all(1.5),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/app_icon.png',
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                      )),
                ],
              ),
            )),
      ],
    ),
  );
}
