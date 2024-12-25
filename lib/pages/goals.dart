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
    // Variables to calculate the weighted average score
    double totalWeightedScore = 0.0;
    int totalWeight = 0;

    // Calculate weighted score for each goal
    for (var goal in goals) {
      double goalScore = _goalController.calculateGoalScore(goal);
      int goalWeight =
          goal['weight'] ?? 1; // Default weight is 1 if not provided
      totalWeightedScore += goalScore * goalWeight;
      totalWeight += goalWeight;
    }

    // Calculate the weighted average score
    double averageScore =
        totalWeight > 0 ? totalWeightedScore / totalWeight : 0.0;

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
          // Render the goals list
          if (goals.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  double goalScore =
                      _goalController.calculateGoalScore(goals[index]);

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                                  key: ValueKey(
                                      goals[index]['id']), // Unique Key
                                  isChecked: goals[index]['isChecked'],
                                  onChanged: (newState) {
                                    setState(() {
                                      goals[index]['isChecked'] = newState;
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      goals[index]['title'],
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
            )
          else
            // Show message when the goals list is empty
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
