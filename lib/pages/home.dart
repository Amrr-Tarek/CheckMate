import 'package:checkmate/controllers/firestore_controller.dart';
import 'package:checkmate/controllers/goal_controller.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/const/colors.dart';
// import 'package:checkmate/models/buttons.dart';
import 'package:checkmate/models/app_bar.dart';
import 'package:checkmate/models/drawer.dart';
import 'package:checkmate/const/messages.dart';
class HomePage extends StatefulWidget {
  final String title = "Home";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Dashboard", showIcon: true),
      drawer: MyDrawer.createDrawer(context, "dashboard"),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _nameXP(),
                  _graph(),
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

  Container _graph() {
    return Container(
      color: Colors.red,
      height: 200,
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

  Container _nameXP() {
    return Container(
      height: 80,
      color: Colors.amber,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FutureBuilder<String>(
            future: FirestoreDataSource().getName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData && snapshot.data != "FAIL") {
                return Text(
                  snapshot.data!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                );
              } else {
                return const Text('Failed to load name');
              }
            },
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
}
