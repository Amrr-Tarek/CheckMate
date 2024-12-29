import 'package:checkmate/controllers/auth_controller.dart';
import 'package:checkmate/controllers/firestore_controller.dart';
import 'package:checkmate/controllers/user_provider.dart';
import 'package:checkmate/models/buttons.dart';
import 'package:checkmate/models/display_info.dart';
import 'package:checkmate/models/user_model.dart';
import 'package:checkmate/controllers/goal_controller.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:checkmate/data/Line_chart_data.dart';
import 'package:checkmate/const/colors.dart';
import 'package:checkmate/models/app_bar.dart';
import 'package:checkmate/models/drawer.dart';
import 'package:checkmate/const/messages.dart';
import 'package:provider/provider.dart';
class HomePage extends StatefulWidget {
  final String title = "Home";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> goals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      // Fetch goals data
      List<Map<String, dynamic>> fetchedGoals = await FirestoreDataSource().getUncheckedGoals();
      setState(() {
        goals = fetchedGoals;
        isLoading = false;
      });
    } catch (e) {
      // Handle any errors here if needed
      setState(() {
        isLoading = false;
      });
    }
  }

  // Is ran everytime setState is called
  @override
  Widget build(BuildContext context) {
    UserModel user = context.watch<UserProvider>().user;

    // create an instance of LineDate that contains random data
    final data = LineData();
    return Scaffold(
      appBar: appBar(context, "Dashboard", showIcon: true),
      drawer: MyDrawer.createDrawer(context, "dashboard"),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _nameXP(user.name, user.xp),
                  _graph(data),
                  SizedBox(height: 10),
                  _goals(),
                ],
              ),
            ),
      // Uncomment and implement the bottomNavigationBar if needed
      // bottomNavigationBar: myBottomNavBar(),
    );
  }

Column _goals() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          "My Goals",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
      ),
      goals.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "All caught up!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    Messages.NoUnCheckedGoals,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: goals.length,
              separatorBuilder: (context, index) => SizedBox(height: 10),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final goal = goals[index];
                final title = goal['title'] ?? "Untitled";
                final deadline = goal['deadline'] != null
                    ? (goal['deadline'] as DateTime).toLocal()
                    : null;
                final weight = goal['weight'] ?? 1; // Default to 1 if weight is not available
                final weightLabel = GoalController().getWeightLabel(weight);

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppColors.textColor, width: 1),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        if (deadline != null)
                          Text(
                            "Deadline: ${deadline.toString().split(' ')[0]}",
                            style: TextStyle(fontSize: 14, color: AppColors.textColor),
                          ),
                        Text(
                          "Weight: $weightLabel",
                          style: TextStyle(fontSize: 14, color: AppColors.textColor),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
