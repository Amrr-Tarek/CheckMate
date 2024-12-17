import 'package:flutter/material.dart';
import 'package:checkmate/const/messages.dart';

class Activitycontroller{
    void addRoutine(List<Map<String, dynamic>> activities, context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController activityTextController =
            TextEditingController();
        final TextEditingController activityIntervalController =
            TextEditingController();
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
                    keyboardType:
                        TextInputType.number, // Only allow numeric input
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
                        errorMessage =
                            "Please enter both description and interval.";
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
// Function to handle editing an activity
  void editActivity(BuildContext context, int index,
      List<Map<String, dynamic>> activityList, Function setState) {
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

                if (description.isEmpty ||
                    interval.isEmpty ||
                    intervalValue == null) {
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
    // Function to add a routine (activity)
  // Function to remove an activity
  void removeActivity(int index, Function setState, List<Map<String, dynamic>> activities) {
    setState(() {
      activities.removeAt(index);
    });
  }

  int unCheckAllActivities(Function setState, activities) {
    int unChecked = 0;// I use unChecked to count how many activity isn't checked after one day which effects the rating later.
    setState(() {
      for (dynamic activity in activities) {
        if (activity["isChecked"] ==  true){
          activity["isChecked"] = false;
          unChecked ++;
        }
      }
    });
    return unChecked;
  }
}