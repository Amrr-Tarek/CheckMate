import 'package:checkmate/controllers/user_provider.dart';
import 'package:checkmate/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/const/colors.dart';
// import 'package:checkmate/models/buttons.dart';
import 'package:checkmate/models/app_bar.dart';
import 'package:checkmate/models/drawer.dart';
import 'package:checkmate/models/tasks_home.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final String title = "Home";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // add sth
  int _currentIndex = 0;

  List<TaskModel> tasks = [];
  // final List _pages = ['/home', '/routine', '/goals', '/myprofile'];

  void fetchData() {
    tasks = TaskModel.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    // Is ran everytime setState is called
    UserProvider userProvider = Provider.of<UserProvider>(context);
    UserModel user = userProvider.user;
    fetchData();
    return Scaffold(
      appBar: appBar(context, "Dashboard", showIcon: true),
      drawer: MyDrawer.createDrawer(context, "dashboard"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _nameXP(user.name, user.xp),
            _graph(),
            SizedBox(height: 10),
            _tasks(),
          ],
        ),
      ),
      // bottomNavigationBar: myBottomNavBar(), // Non-functional
    );
  }

  BottomNavigationBar myBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      fixedColor: Colors.black,
      backgroundColor: AppColors.barColor,
      currentIndex: _currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            _currentIndex == 0 ? Icons.home : Icons.home_outlined,
            color: Colors.black,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            _currentIndex == 1 ? Icons.repeat_on : Icons.repeat_outlined,
            color: Colors.black,
          ),
          label: 'Routine',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            _currentIndex == 2 ? Icons.album : Icons.album_outlined,
            color: Colors.black,
          ),
          label: 'Goals',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            _currentIndex == 3 ? Icons.person : Icons.person_outlined,
            color: Colors.black,
          ),
          label: 'Profile',
        ),
      ],
    );
  }

  Column _tasks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            "My Tasks",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 6),
        // Use the ListView inside the column without Expanded
        ListView.separated(
          itemCount: tasks.length,
          separatorBuilder: (context, index) => SizedBox(height: 5),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics:
              NeverScrollableScrollPhysics(), // Disable scrolling within this ListView
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              tasks[index].taskName,
              style: TextStyle(fontSize: 18, color: tasks[index].color),
            ),
          ),
        ),
      ],
    );
  }

  Container _graph() {
    return Container(
      color: Colors.red,
      height: 200,
      child: Center(
          child: Text("Visual Graph here",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30))),
    );
  }

  Container _nameXP(String name, int xp) {
    return Container(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // User's Name
          Text(
            name, // Display the name
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            "$xp XP",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
  // Container __body() {
  //   return Container(
  //     margin: const EdgeInsets.all(10),
  //     child: Center(
  //         child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         const Text(
  //           "Hello :)\nThis Page is 'Getting Started' for you to implement the front end of the pages listed in the buttons below\nPress on the button to take you to the page (crazy right?!)\nادعيلي (معرفش ليه بس اخوك محتاج الدعوة)",
  //           style: TextStyle(fontSize: 20),
  //           textAlign: TextAlign.center,
  //         ),
  //         const SizedBox(height: 10),
  //         Button(
  //             text: "Calendar",
  //             onPress: () {
  //               navigate(context, '/calendar');
  //             }),
  //         Button(
  //             text: "Routine",
  //             onPress: () {
  //               navigate(context, '/routine');
  //             }),
  //         Button(
  //             text: "Goals",
  //             onPress: () {
  //               navigate(context, '/goals');
  //             }),
  //         Button(
  //             text: "My Profile",
  //             onPress: () {
  //               navigate(context, '/myprofile');
  //             }),
  //         Button(
  //             text: "Settings",
  //             onPress: () {
  //               navigate(context, "/settings");
  //             }),
  //       ],
  //     )),
  //   );
  // }
}
