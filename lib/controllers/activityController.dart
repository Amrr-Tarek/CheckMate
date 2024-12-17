import 'package:flutter/material.dart';
import 'package:checkmate/const/messages.dart';

class Activitycontroller {
  // Word limit constant
  static const int wordLimit = 10; // Define the word limit

  // Function to check word limit and display the message
  void checkWordLimit(String text, Function setState, Function(String?) updateMessage) {
    int wordCount = text.trim().split(RegExp(r'\s+')).length;
    if (wordCount > wordLimit) {
      updateMessage(Messages.exceedWordLimit(wordLimit)); // Show error if word count exceeds the limit
    } else {
      updateMessage(null); // Clear error if within the limit
    }
  }

  // Function to add a routine (activity)
  void addRoutine(List<Map<String, dynamic>> activities, context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController activityTextController = TextEditingController();
        final TextEditingController activityIntervalController = TextEditingController();
        String? errorMessage; // Error message to display
        String? wordLimitMessage; // Word limit error message

        return StatefulBuilder(
          builder: (context, setState) {
            // Function to update word limit message
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
                      checkWordLimit(value, setState, updateWordLimitMessage); // Check word limit on input change
                    },
                    decoration: InputDecoration(
                      hintText: Messages.enterActivityDescription,
                      errorText: wordLimitMessage, // Show word limit error
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
                    } else if (wordLimitMessage != null) {
                      setState(() {
                        errorMessage = wordLimitMessage;
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
  void editActivity(BuildContext context, int index, List<Map<String, dynamic>> activityList, Function setState) {
    final TextEditingController activityTextController = TextEditingController(text: activityList[index]['text']);
    final TextEditingController activityIntervalController = TextEditingController(text: activityList[index]['interval'].toString());
    String? errorMessage;
    String? wordLimitMessage; // Word limit error message

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Function to update word limit message
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
                      checkWordLimit(value, setState, updateWordLimitMessage); // Check word limit on input change
                    },
                    decoration: InputDecoration(
                      hintText: Messages.enterActivityDescription,
                      errorText: wordLimitMessage, // Show word limit error
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
                    } else if (wordLimitMessage != null) {
                      setState(() {
                        errorMessage = wordLimitMessage;
                      });
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
      },
    );
  }

  // Function to remove an activity
  void removeActivity(int index, Function setState, List<Map<String, dynamic>> activities) {
    setState(() {
      activities.removeAt(index);
    });
  }

  // Function to uncheck all activities and count how many aren't checked
  int unCheckAllActivities(Function setState, activities) {
    int unChecked = 0; // Count of activities that are unchecked
    setState(() {
      for (dynamic activity in activities) {
        if (activity["isChecked"] == true) {
          activity["isChecked"] = false;
          unChecked++;
        }
      }
    });
    return unChecked;
  }
}
