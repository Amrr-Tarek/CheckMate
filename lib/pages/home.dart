import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:checkmate/data/Line_chart_data.dart';
import 'package:checkmate/const/colors.dart';
// import 'package:checkmate/models/buttons.dart';
import 'package:checkmate/models/app_bar.dart';
import 'package:checkmate/models/drawer.dart';
import 'package:checkmate/models/tasks_home.dart';

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

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  void fetchData() {
    tasks = TaskModel.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    // Is ran everytime setState is called
    fetchData();
    // create an instance of LineDate that contains random data
    final data = LineData();
    return Scaffold(
      appBar: appBar(context, "Dashboard", showIcon: true),
      drawer: MyDrawer.createDrawer(context, "dashboard"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _nameXP(),
            _graph(data),
            SizedBox(height: 10),
            _tasks(),
          ],
        ),
      ),
      bottomNavigationBar: myBottomNavBar(), // Non-functional
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

  Container _graph(LineData data) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Progress',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 16 / 6,
            child: LineChart(
                    LineChartData(
                    backgroundColor: const Color(0xFFF0F0F0), // Light grey background
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
                        // Left tittles of the graph
                        // =========================
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                            return data.leftTitle[value.toInt()] != null
                                ? Text(data.leftTitle[value.toInt()].toString(),
                                    style: TextStyle(
                                        fontSize: 12, 
                                        color: Colors.grey.withOpacity(0.5),
                                    ))
                                : const SizedBox();
    
                          },
                          interval: 1,
                          reservedSize: 24,
                          ),
                        ),
                        // Bottom tittles of the graph
                        // =========================
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                            return data.bottomTitle[value.toInt()] != null
                                ? Text(data.bottomTitle[value.toInt()].toString(),
                                    style: TextStyle(
                                        color: Colors.grey.withOpacity(0.5)),)
                                : const SizedBox();
    
                          },
                          interval: 1,
                          reservedSize: 24,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: const Color.fromARGB(255, 37, 34, 97), width: 1),
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
          );
      }
  }

  Container _nameXP() {
    return Container(
      height: 80,
      color: Colors.amber,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Your Name",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            "00XP",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }