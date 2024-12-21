import 'package:checkmate/models/drawer.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/models/app_bar.dart';
import 'package:checkmate/controllers/goalController.dart';

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
    // Sort goals: unchecked first
    goals.sort((a, b) => a['isChecked'] == b['isChecked'] ? 0 : (a['isChecked'] ? 1 : -1));

    return Scaffold(
      appBar: appBar(context, "Goals"),
      drawer: MyDrawer.createDrawer(context, "goals"),
      body: ListView.builder(
        itemCount: goals.length,
        itemBuilder: (context, index) {
          final goal = goals[index];
          return Card(
            child: ListTile(
              title: Text(goal['title']),
              leading: Checkbox(
                value: goal['isChecked'],
                onChanged: (value) {
                  setState(() {
                    goal['isChecked'] = value;
                  });
                },
              ),
              onTap: () => _goalController.showGoalDetails(context, index, goals, setState),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _goalController.addGoal(context, goals, setState);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
