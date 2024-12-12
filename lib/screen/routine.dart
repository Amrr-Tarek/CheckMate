import 'package:flutter/material.dart';
import 'package:checkmate/const/colors.dart';
import 'package:checkmate/const/buttons.dart';
import 'package:checkmate/const/messages.dart';

class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  List<Map<String, dynamic>> activities =
      []; // List to store activities and their checked states

  // Function to add a routine (activity)
void _addRoutine() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final TextEditingController activityTextController = TextEditingController();
      final TextEditingController activityIntervalController = TextEditingController();
      String? errorMessage; // Error message to display

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text(Messages.addActivity),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: activityTextController,
                  decoration: const InputDecoration(
                    hintText: Messages.enterActivityDescription,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: activityIntervalController,
                  keyboardType: TextInputType.number, // Only allow numeric input
                  decoration: const InputDecoration(
                    hintText: Messages.enterActivityInterval,
                  ),
                ),
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(Messages.cancelButtonText),
              ),
              TextButton(
                onPressed: () {
                  final description = activityTextController.text;
                  final interval = activityIntervalController.text;
                  final intervalValue = int.tryParse(interval);

                  if (description.isEmpty || interval.isEmpty) {
                    setState(() {
                      errorMessage = "Please enter both description and interval.";
                    });
                  } else if (intervalValue == null) {
                    setState(() {
                      errorMessage = Messages.activityInputError;
                    });
                  } else {
                    setState(() {
                      activities.add({
                        'text': description,
                        'interval': intervalValue,
                        'isChecked': false,
                      });
                      errorMessage = null; // Clear error
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(Messages.addButtonText),
              ),
            ],
          );
        },
      );
    },
  );
}

  // Function to remove an activity
  void _removeActivity(int index) {
    setState(() {
      activities.removeAt(index);
    });
  }

@override
Widget build(BuildContext context) {
  // Separate activities into checked and unchecked
  List<Map<String, dynamic>> checkedActivities =
      activities.where((activity) => activity['isChecked']).toList();
  List<Map<String, dynamic>> uncheckedActivities =
      activities.where((activity) => !activity['isChecked']).toList();

  return Scaffold(
    appBar: AppBar(
      backgroundColor: AppColors.backgroundColor,
      title: const Text("Routine page"),
    ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                                isChecked: uncheckedActivities[index]['isChecked'],
                                onChanged: (newState) {
                                  setState(() {
                                    uncheckedActivities[index]['isChecked'] = newState;
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                                isChecked: checkedActivities[index]['isChecked'],
                                onChanged: (newState) {
                                  setState(() {
                                    checkedActivities[index]['isChecked'] = newState;
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
      onPressed: _addRoutine,
      backgroundColor: AppColors.boxColor,
      child: const Icon(Icons.add, color: Colors.white),
    ),
  );
}

// Function to show "Edit" and "Delete" options
void _showTaskOptions(BuildContext context, int index, List<Map<String, dynamic>> activityList) {
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
                _editActivity(context, index, activityList);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                _removeActivity(index);
              },
            ),
          ],
        ),
      );
    },
  );
}

// Function to handle editing an activity
void _editActivity(BuildContext context, int index, List<Map<String, dynamic>> activityList) {
  final TextEditingController activityTextController =
      TextEditingController(text: activityList[index]['text']);
  final TextEditingController activityIntervalController =
      TextEditingController(text: activityList[index]['interval'].toString());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(Messages.editActivity),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: activityTextController,
              decoration: const InputDecoration(
                hintText: Messages.enterActivityDescription,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: activityIntervalController,
              keyboardType: TextInputType.number, // Only allow numeric input
              decoration: const InputDecoration(
                hintText: Messages.enterActivityInterval,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(Messages.cancelButtonText),
          ),
          TextButton(
            onPressed: () {
              final description = activityTextController.text;
              final interval = activityIntervalController.text;
              final intervalValue = int.tryParse(interval);

              if (description.isEmpty || interval.isEmpty || intervalValue == null) {
                return;
              } else {
                setState(() {
                  activityList[index]['text'] = description;
                  activityList[index]['interval'] = intervalValue;
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text(Messages.saveButtonText),
          ),
        ],
      );
    },
  );
  }
}