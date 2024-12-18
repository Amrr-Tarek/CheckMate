import 'package:checkmate/models/app_bar.dart';
import 'package:checkmate/models/drawer.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/const/colors.dart';
import 'package:checkmate/models/buttons.dart';
import 'package:checkmate/const/messages.dart';
import 'package:checkmate/controllers/activityController.dart';
import 'dart:async';

class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  List<Map<String, dynamic>> activities =
      []; // List to store activities and their checked states

  @override
  Widget build(BuildContext context) {
    Activitycontroller activityController = Activitycontroller();
    Timer.periodic(
      const Duration(days: 1),
      (Timer t) {
        int unCheckedAfterDay = activityController.unCheckAllActivities(
            setState, activities); // Capture the return value
      },
    );

    // Separate activities into checked and unchecked
    List<Map<String, dynamic>> checkedActivities =
        activities.where((activity) => activity['isChecked']).toList();
    List<Map<String, dynamic>> uncheckedActivities =
        activities.where((activity) => !activity['isChecked']).toList();

    return Scaffold(
      appBar: appBar(context, "Routine"),
      drawer: MyDrawer.createDrawer(context, "routine"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dynamic ListView for unchecked activities
          if (uncheckedActivities.isNotEmpty)
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: uncheckedActivities.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                        _showTaskOptions(context, index, uncheckedActivities);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CheckBoxWidget(
                                  isChecked: uncheckedActivities[index]
                                      ['isChecked'],
                                  onChanged: (newState) {
                                    setState(() {
                                      uncheckedActivities[index]['isChecked'] =
                                          newState;
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  uncheckedActivities[index]['text'],
                                  style: const TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '${uncheckedActivities[index]['interval']} min',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                  ),
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
          // If no unchecked activities, show a message
          if (uncheckedActivities.isEmpty && checkedActivities.isNotEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                Messages.finishActivities,
                style: TextStyle(
                  fontSize: 32,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else if (uncheckedActivities.isEmpty && checkedActivities.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                Messages.motivationToAddActivities,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          // ListView to display checked activities
          if (checkedActivities.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: checkedActivities.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                        _showTaskOptions(context, index, checkedActivities);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CheckBoxWidget(
                                  isChecked: checkedActivities[index]
                                      ['isChecked'],
                                  onChanged: (newState) {
                                    setState(() {
                                      checkedActivities[index]['isChecked'] =
                                          newState;
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  checkedActivities[index]['text'],
                                  style: const TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '${checkedActivities[index]['interval']} min',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                  ),
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
          activityController.addRoutine(activities, context);
        },
        backgroundColor: AppColors.boxColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

// Function to show "Edit" and "Delete" options
  void _showTaskOptions(BuildContext context, int index,
      List<Map<String, dynamic>> activityList) {
    Activitycontroller activityController = Activitycontroller();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  activityController.editActivity(
                      context, index, activityList, setState);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  activityController.removeActivity(
                      index, setState, activities);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
