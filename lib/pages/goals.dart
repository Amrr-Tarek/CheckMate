import 'package:flutter/material.dart';
import 'package:checkmate/models/drawer.dart';
import 'package:checkmate/models/app_bar.dart';
import 'package:checkmate/controllers/goalController.dart';
import 'package:checkmate/models/buttons.dart';
import 'package:checkmate/const/messages.dart';
import 'package:checkmate/const/colors.dart';

class Event {
  final String title;
  Event({required this.title});
}

class Goals extends StatefulWidget {
  const Goals({super.key});

  @override
  State<Goals> createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  List<Map<String, dynamic>> goals = [];
  final GoalController _goalController = GoalController();

  @override
  Widget build(BuildContext context) {
    // Separate goals into checked and unchecked
    List<Map<String, dynamic>> checkedGoals =
        goals.where((goal) => goal['isChecked']).toList();
    List<Map<String, dynamic>> uncheckedGoals =
        goals.where((goal) => !goal['isChecked']).toList();

    // Variables to calculate the weighted average score
    double totalWeightedScore = 0.0;
    int totalWeight = 0;

    // Calculate weighted score for each goal
    for (var goal in goals) {
      double goalScore = _goalController.calculateGoalScore(goal);
      int goalWeight = goal['weight'] ?? 1; // Default weight is 1 if not provided
      totalWeightedScore += goalScore * goalWeight;
      totalWeight += goalWeight;
    }

    // Calculate the weighted average score
    double averageScore = totalWeight > 0 ? totalWeightedScore / totalWeight : 0.0;

    return Scaffold(
      appBar: appBar(context, "Goals"),
      drawer: MyDrawer.createDrawer(context, "goals"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show the total score at the top
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Total Score: ${averageScore.toStringAsFixed(2)}%',
              style: const TextStyle(
                fontSize: 24,
                color: AppColors.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Dynamic ListView for unchecked goals
          if (uncheckedGoals.isNotEmpty)
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: uncheckedGoals.length,
                itemBuilder: (context, index) {
                  double goalScore =
                      _goalController.calculateGoalScore(uncheckedGoals[index]);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                        _goalController.showGoalDetails(
                            context, index, goals, setState);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CheckBoxWidget(
                                  isChecked: uncheckedGoals[index]['isChecked'],
                                  onChanged: (newState) {
                                    setState(() {
                                      // Update the original `goals` list
                                      int originalIndex =
                                          goals.indexOf(uncheckedGoals[index]);
                                      if (originalIndex != -1) {
                                        goals[originalIndex]['isChecked'] =
                                            newState;
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      uncheckedGoals[index]['title'],
                                      style: const TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // Display the individual score here
                                    Text(
                                      'Score: ${goalScore.toStringAsFixed(2)}%',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          // Show message when no unchecked goals and some goals are checked
          if (uncheckedGoals.isEmpty && checkedGoals.isNotEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                Messages.finish,
                style: TextStyle(
                  fontSize: 32,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          // Show message when both checked and unchecked goals are empty
          if (uncheckedGoals.isEmpty && checkedGoals.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                Messages.motivationToAddGoals,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          // ListView to display checked goals
          if (checkedGoals.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: checkedGoals.length,
                itemBuilder: (context, index) {
                  double goalScore =
                      _goalController.calculateGoalScore(checkedGoals[index]);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                        _goalController.showGoalDetails(
                            context, index, goals, setState);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CheckBoxWidget(
                                  isChecked: checkedGoals[index]['isChecked'],
                                  onChanged: (newState) {
                                    setState(() {
                                      // Update the original `goals` list
                                      int originalIndex =
                                          goals.indexOf(checkedGoals[index]);
                                      if (originalIndex != -1) {
                                        goals[originalIndex]['isChecked'] =
                                            newState;
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      checkedGoals[index]['title'],
                                      style: const TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // Display the individual score here
                                    Text(
                                      'Score: ${goalScore.toStringAsFixed(2)}%',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _goalController.addGoal(context, goals, setState);
        },
        backgroundColor: AppColors.boxColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
