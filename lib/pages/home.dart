import 'package:checkmate/controllers/auth_controller.dart';
import 'package:checkmate/controllers/user_provider.dart';
import 'package:checkmate/models/buttons.dart';
import 'package:checkmate/models/display_info.dart';
import 'package:checkmate/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:checkmate/data/Line_chart_data.dart';
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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    tasks = TaskModel.getTasks();
  }

  // Is ran everytime setState is called
  @override
  Widget build(BuildContext context) {
    UserModel user = context.watch<UserProvider>().user;

    fetchData();
    // create an instance of LineDate that contains random data
    final data = LineData();
    return Scaffold(
      appBar: appBar(context, "Dashboard", showIcon: true),
      drawer: MyDrawer.createDrawer(context, "dashboard"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _nameXP(user.name, user.xp),
            _graph(data),
            SizedBox(height: 20),
            _tasks(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Button(
                label: "Check if user is logged in",
                onPressed: () async {
                  // don't use auth controller here
                  bool isLoggedIn = await AuthController().isUserLoggedIn();
                  if (isLoggedIn) {
                    showSnackBar(context, "User is logged in");
                  } else {
                    showSnackBar(context, "No user is logged in");
                  }
                },
                backgroundColor: AppColors.boxColor,
                textColor: AppColors.backgroundColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                borderRadius: 24.0,
                height: 48.0,
              ),
            ),
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
      backgroundColor: Theme.of(context).primaryColor,
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
          padding: const EdgeInsets.all(16),
          child: Text(
            "My Tasks",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).secondaryHeaderColor,
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

  Container _graph(LineData data) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: data.spots.isEmpty // Check if the data is empty
          ? Center(
              child: Text(
                "Visual Graph here",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Your Progress',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  AspectRatio(
                    aspectRatio: 16 / 6,
                    child: LineChart(
                      LineChartData(
                        backgroundColor:
                            const Color(0xFFF0F0F0), // Light grey background
                        lineTouchData: LineTouchData(
                          handleBuiltInTouches: true,
                        ),
                        gridData: FlGridData(
                          show: false,
                        ),
                        titlesData: FlTitlesData(
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                          // Left titles of the graph
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return data.leftTitle[value.toInt()] != null
                                    ? Text(
                                        data.leftTitle[value.toInt()]
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const SizedBox();
                              },
                              interval: 1,
                              reservedSize: 24,
                            ),
                          ),
                          // Bottom titles of the graph
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return data.bottomTitle[value.toInt()] != null
                                    ? Text(
                                        data.bottomTitle[value.toInt()]
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )
                                    : const SizedBox();
                              },
                              interval: 1,
                              reservedSize: 24,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: const Color.fromARGB(255, 37, 34, 97),
                            width: 1,
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: data.spots,
                            dotData: FlDotData(show: false),
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.blue, Colors.purple],
                            ),
                            color: const Color.fromARGB(255, 24, 121, 102),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                        minX: 0,
                        maxX: 120,
                        minY: 0,
                        maxY: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Container _nameXP(String name, int xp) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.8),
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
