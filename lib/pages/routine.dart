import 'package:checkmate/models/app_bar.dart';
import 'package:checkmate/models/drawer.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/const/colors.dart';
import 'package:checkmate/models/buttons.dart';
import 'package:checkmate/const/messages.dart';
import 'package:checkmate/controllers/activity_controller.dart';
import 'dart:async';
import 'package:checkmate/controllers/firestore_controller.dart';

class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  List<Map<String, dynamic>> activities = []; // List to store activities and their checked states
  ActivityController activityController = ActivityController();

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  // Load activities from Firestore
  Future<void> _loadActivities() async {
    activities = await FirestoreDataSource().getAllRoutines();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Separate activities into checked and unchecked
    List<Map<String, dynamic>> checkedActivities =
        activities.where((activity) => activity['isChecked']).toList();
    List<Map<String, dynamic>> uncheckedActivities =
        activities.where((activity) => !activity['isChecked']).toList();

    return Scaffold(
      appBar: appBar(context, "Routine"),
      drawer: MyDrawer.createDrawer(context, "routine"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
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
                                            ['isChecked'] ??
                                        false, // Default to false if null
                                    onChanged: (newState) async {
                                      setState(() {
                                        uncheckedActivities[index]
                                            ['isChecked'] = newState ?? false; // Ensure it's not null
                                      });

                                      // Update Firestore with the new checked state
                                      await FirestoreDataSource().CheckRoutine(
                                        routine_id: uncheckedActivities[index]
                                            ['id'],
                                        check_uncheck: newState ?? false, // Ensure it's not null
                                      );

                                      // Reflect changes in the main activities list
                                      activities[activities.indexWhere(
                                              (activity) =>
                                                  activity['id'] ==
                                                  uncheckedActivities[index]
                                                      ['id'])]
                                          ['isChecked'] = newState ?? false;
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
                  Messages.finish,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
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
                                            ['isChecked'] ??
                                        false, // Default to false if null
                                    onChanged: (newState) async {
                                      setState(() {
                                        checkedActivities[index]
                                            ['isChecked'] = newState ?? false; // Ensure it's not null
                                      });

                                      // Update Firestore with the new checked state
                                      await FirestoreDataSource().CheckRoutine(
                                        routine_id: checkedActivities[index]
                                            ['id'],
                                        check_uncheck: newState ?? false, // Ensure it's not null
                                      );

                                      // Reflect changes in the main activities list
                                      activities[activities.indexWhere(
                                              (activity) =>
                                                  activity['id'] ==
                                                  checkedActivities[index]
                                                      ['id'])]
                                          ['isChecked'] = newState ?? false;
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          List<Map<String, dynamic>> updatedActivities =
              await activityController.addRoutine(activities, context);
          setState(() {
            activities = updatedActivities;
          });
        },
        backgroundColor: AppColors.boxColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Function to show "Edit" and "Delete" options
  void _showTaskOptions(BuildContext context, int index,
      List<Map<String, dynamic>> activityList) {
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
                onTap: () async {
                  Navigator.pop(context);
                  List<Map<String, dynamic>> updatedActivities =
                      await activityController.editActivity(
                          context, index, activityList);
                  setState(() {
                    activities = updatedActivities;
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete'),
                onTap: () async {
                  Navigator.pop(context);
                  List<Map<String, dynamic>> updatedActivities =
                      await activityController.removeActivity(
                          index, activities);
                  setState(() {
                    activities = updatedActivities;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
