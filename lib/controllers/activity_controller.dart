import 'package:checkmate/controllers/firestore_controller.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/const/messages.dart';

class ActivityController {
  // Word limit constant
  static const int wordLimit = 10; // Define the word limit

  // Function to check word limit and display the message
  void checkWordLimit(String text, Function(String?) updateMessage) {
    int wordCount = text.trim().split(RegExp(r'\s+')).length;
    if (wordCount > wordLimit) {
      updateMessage(Messages.exceedWordLimit(wordLimit)); // Show error if word count exceeds the limit
    } else {
      updateMessage(null); // Clear error if within the limit
    }
  }

  // Function to add a routine (activity)
  Future<List<Map<String, dynamic>>> addRoutine(List<Map<String, dynamic>> activities, BuildContext context) async {
    final TextEditingController activityTextController = TextEditingController();
    final TextEditingController activityIntervalController = TextEditingController();
    String? errorMessage;
    String? wordLimitMessage;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void updateWordLimitMessage(String? message) {
              setState(() {
                wordLimitMessage = message;
              });
            }

            return AlertDialog(
              title: const Text(Messages.addActivity),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: activityTextController,
                    maxLines: 2,
                    onChanged: (value) {
                      checkWordLimit(value, updateWordLimitMessage); // Check word limit on input change
                    },
                    decoration: InputDecoration(
                      hintText: Messages.enterActivityDescription,
                      errorText: wordLimitMessage, // Show word limit error
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: activityIntervalController,
                    keyboardType: TextInputType.number,
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
                    } else if (wordLimitMessage != null) {
                      setState(() {
                        errorMessage = wordLimitMessage;
                      });
                    } else {
                      FirestoreDataSource().addRoutine(description, intervalValue);
                      activities.add({
                        'text': description,
                        'interval': intervalValue,
                        'isChecked': false,
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
    return activities;
  }

  // Function to handle editing an activity
  Future<List<Map<String, dynamic>>> editActivity(
    BuildContext context,
    int index,
    List<Map<String, dynamic>> activities,
  ) async {
    final TextEditingController activityTextController = TextEditingController(text: activities[index]['text']);
    final TextEditingController activityIntervalController = TextEditingController(text: activities[index]['interval'].toString());
    String? wordLimitMessage;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void updateWordLimitMessage(String? message) {
              setState(() {
                wordLimitMessage = message;
              });
            }

            return AlertDialog(
              title: const Text(Messages.editActivity),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: activityTextController,
                    maxLines: 2,
                    onChanged: (value) {
                      checkWordLimit(value, updateWordLimitMessage);
                    },
                    decoration: InputDecoration(
                      hintText: Messages.enterActivityDescription,
                      errorText: wordLimitMessage,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: activityIntervalController,
                    keyboardType: TextInputType.number,
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
                    } else if (wordLimitMessage != null) {
                      return;
                    } else {
                      activities[index]['text'] = description;
                      activities[index]['interval'] = intervalValue;
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(Messages.saveButtonText),
                ),
              ],
            );
          },
        );
      },
    );
    return activities;
  }

  // Function to remove an activity
  List<Map<String, dynamic>> removeActivity(int index, List<Map<String, dynamic>> activities) {
    activities.removeAt(index);
    return activities;
  }

  // Function to uncheck all activities
  List<Map<String, dynamic>> uncheckAllActivities(List<Map<String, dynamic>> activities) {
    for (var activity in activities) {
      activity['isChecked'] = false;
    }
    return activities;
  }
}
