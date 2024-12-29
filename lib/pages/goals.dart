import 'package:flutter/material.dart';
import 'package:checkmate/models/drawer.dart';
import 'package:checkmate/models/app_bar.dart';
import 'package:checkmate/controllers/goal_controller.dart';
import 'package:checkmate/models/buttons.dart';
import 'package:checkmate/const/messages.dart';
import 'package:checkmate/const/colors.dart';
import 'package:checkmate/controllers/firestore_controller.dart';

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
  final FirestoreDataSource _firestoreDataSource = FirestoreDataSource();

  @override
  void initState() {
    super.initState();
    _fetchGoals(); // Call the fetch function when the page is initialized
  }

  // Fetch the goals from Firestore and update the state
Future<void> _fetchGoals() async {
  try {
    // Fetch goals from Firestore
    List<Map<String, dynamic>> fetched_goals = await FirestoreDataSource().getAllGoals();

    // Set the goals list in the state
    setState(() {
      goals = fetched_goals;
    });
  } catch (e) {
    print("Error fetching goals: $e");
  }
}


  Future<void> _updateGoal(int index) async {
    final goal = goals[index];

    // Recalculate score and check if all subtasks are completed
    setState(() {
      goal['score'] = _goalController.calculateGoalScore(goal);
      goal['isChecked'] = goal['subtasks'].every((subtask) => subtask['isChecked']);
    });

    // Update Firestore
    try {
      await _firestoreDataSource.updateGoal(
        goal['id'],
        goal['subtasks'],
        goal['isChecked'],
        goal['score'],
      );
    } catch (e) {
      print("Error updating goal in Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                // color: AppColors.textColor,
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
                  double goalScore = _goalController.calculateGoalScore(goals[index]);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                        _goalController.showGoalDetails(
                          context,
                          index,
                          goals,
                          (fn) {
                            setState(fn);
                            _updateGoal(index);
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CheckBoxWidget(
                                  key: ValueKey(goals[index]['id']), // Unique Key
                                  isChecked: goals[index]['isChecked'],
                                  onChanged: (newState) async {
                                    setState(() {
                                      goals[index]['isChecked'] = newState;
                                    });
                                    await _updateGoal(index);
                                  },
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      goals[index]['title'],
                                      style: const TextStyle(
                                        // color: AppColors.textColor,
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
