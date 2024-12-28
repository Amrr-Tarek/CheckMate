import 'package:checkmate/controllers/user_provider.dart';
import 'package:checkmate/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/const/colors.dart';
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
  int _currentIndex = 0;

  List<TaskModel> tasks = [];

  void fetchData() {
    tasks = TaskModel.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = context.watch<UserProvider>().user;

    fetchData();
    return Scaffold(
      appBar: appBar(context, "Dashboard", showIcon: true),
      drawer: MyDrawer.createDrawer(context, "dashboard"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _nameXP(user.name, user.xp),
            _graph(),
            SizedBox(height: 20),  // Increased spacing
            _tasks(),
          ],
        ),
      ),
      // bottomNavigationBar: myBottomNavBar(),
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
      backgroundColor: Theme.of(context).primaryColor,  // Use primaryColor from the theme
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

  // Enhanced styling for tasks
  Column _tasks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "My Tasks",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).secondaryHeaderColor,  // Use secondaryHeaderColor
            ),
          ),
        ),
        ListView.separated(
          itemCount: tasks.length,
          separatorBuilder: (context, index) => SizedBox(height: 10),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppColors.borderColor, width: 1),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                tasks[index].taskName,
                style: TextStyle(fontSize: 18, color: tasks[index].color),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container _graph() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,  // Use primaryColor for the graph container
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),  // Shadow color from the theme
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          "Visual Graph here",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
    );
  }

  // Enhanced styling for name and XP
  Container _nameXP(String name, int xp) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.8),  // Use primaryColor for the background
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "$xp XP",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
