import 'package:flutter/material.dart';
import 'package:checkmate/const/messages.dart';

class GoalController {
  static const int Max_title_chars = 50;

  // Subtask validation logic
void validateSubtask(String subtaskTitle, String subtaskDeadline, String? errorMessage, Function dialogSetState, List<Map<String, dynamic>> subtasks) {
  if (subtaskTitle.isEmpty || subtaskDeadline.isEmpty) {
    dialogSetState(() {
      errorMessage = Messages.tittle_And_Deadline_Required;
    });
  } else if (subtaskTitle.length > Max_title_chars) {
    dialogSetState(() {
      errorMessage = Messages.exceedCharLimit(Max_title_chars);
    });
  } else if (DateTime.tryParse(subtaskDeadline) == null) {
    dialogSetState(() {
      errorMessage = Messages.invalid_deadline;
    });
  } else {
    dialogSetState(() {
      errorMessage = null; // Clear any previous errors
      subtasks.add({
        'title': subtaskTitle,
        'deadline': subtaskDeadline,
        'isChecked': false,
      });
    });
  }
}


  // Add a new goal to the state
  void addGoal(BuildContext context, List<Map<String, dynamic>> goals, Function setState) {
    final TextEditingController goalTitleController = TextEditingController();
    final TextEditingController goalDeadlineController = TextEditingController();
    final TextEditingController subtaskTitleController = TextEditingController();
    final TextEditingController subtaskDeadlineController = TextEditingController();
    List<Map<String, dynamic>> subtasks = [];
    String? errorMessage;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              title: const Text("Add Goal"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: goalTitleController,
                      decoration: const InputDecoration(
                        hintText: "Enter goal title",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: goalDeadlineController,
                      decoration: const InputDecoration(
                        hintText: "Enter deadline (YYYY-MM-DD)",
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: subtaskTitleController,
                      decoration: const InputDecoration(
                        hintText: "Enter subtask title",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: subtaskDeadlineController,
                      decoration: const InputDecoration(
                        hintText: "Enter subtask deadline (YYYY-MM-DD)",
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        final subtaskTitle = subtaskTitleController.text.trim();
                        final subtaskDeadline = subtaskDeadlineController.text.trim();

                        validateSubtask(subtaskTitle, subtaskDeadline, errorMessage, dialogSetState, subtasks);
                        subtaskTitleController.clear();
                        subtaskDeadlineController.clear();
                      },
                      child: const Text("Add Subtask"),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 8.0,
                        children: subtasks.map((task) {
                          return Chip(
                            label: Text("${task['title']} - ${task['deadline']}"),
                            onDeleted: () {
                              dialogSetState(() {
                                subtasks.remove(task);
                              });
                            },
                          );
                        }).toList(),
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
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    final title = goalTitleController.text.trim();
                    final deadline = goalDeadlineController.text.trim();

                    if (title.isEmpty || deadline.isEmpty) {
                      dialogSetState(() {
                        errorMessage = Messages.tittle_And_Deadline_Required;
                      });
                    } else if (title.length > Max_title_chars) {
                      dialogSetState(() {
                        errorMessage = Messages.exceedCharLimit(Max_title_chars);
                      });
                    } else if (DateTime.tryParse(deadline) == null) {
                      dialogSetState(() {
                        errorMessage = "Invalid goal deadline format.";
                      });
                    } else {
                      setState(() {
                        goals.add({
                          'title': title,
                          'deadline': deadline,
                          'subtasks': subtasks,
                          'isChecked': false,
                          'score': 0,
                        });
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Edit an existing goal
  void editGoal(BuildContext context, int index, List<Map<String, dynamic>> goals, Function setState) {
    final TextEditingController goalTitleController = TextEditingController(text: goals[index]['title']);
    final TextEditingController goalDeadlineController = TextEditingController(text: goals[index]['deadline']);
    final TextEditingController subtaskTitleController = TextEditingController();
    final TextEditingController subtaskDeadlineController = TextEditingController();
    List<Map<String, dynamic>> subtasks = List<Map<String, dynamic>>.from(goals[index]['subtasks']);
    String? errorMessage;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              title: const Text("Edit Goal"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: goalTitleController,
                      decoration: const InputDecoration(
                        hintText: "Edit goal title",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: goalDeadlineController,
                      decoration: const InputDecoration(
                        hintText: "Edit deadline (YYYY-MM-DD)",
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: subtaskTitleController,
                      decoration: const InputDecoration(
                        hintText: "Enter subtask title",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: subtaskDeadlineController,
                      decoration: const InputDecoration(
                        hintText: "Enter subtask deadline (YYYY-MM-DD)",
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        final subtaskTitle = subtaskTitleController.text.trim();
                        final subtaskDeadline = subtaskDeadlineController.text.trim();

                        validateSubtask(subtaskTitle, subtaskDeadline, errorMessage, dialogSetState, subtasks);
                        subtaskTitleController.clear();
                        subtaskDeadlineController.clear();
                      },
                      child: const Text("Add Subtask"),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 8.0,
                        children: subtasks.map((task) {
                          return Chip(
                            label: Text("${task['title']} - ${task['deadline']}"),
                            onDeleted: () {
                              dialogSetState(() {
                                subtasks.remove(task);
                              });
                            },
                          );
                        }).toList(),
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
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    final title = goalTitleController.text.trim();
                    final deadline = goalDeadlineController.text.trim();

                    if (title.isEmpty || deadline.isEmpty) {
                      dialogSetState(() {
                        errorMessage = Messages.tittle_And_Deadline_Required;
                      });
                    } else if (title.length > Max_title_chars) {
                      dialogSetState(() {
                        errorMessage = Messages.exceedCharLimit(Max_title_chars);
                      });
                    } else if (DateTime.tryParse(deadline) == null) {
                      dialogSetState(() {
                        errorMessage = Messages.invalid_deadline;
                      });
                    } else {
                      setState(() {
                        goals[index] = {
                          'title': title,
                          'deadline': deadline,
                          'subtasks': subtasks,
                          'isChecked': goals[index]['isChecked'],
                          'score': goals[index]['score'],
                        };
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }
  // Show goal details in a separate screen and allow interaction with subtasks
  void showGoalDetails(BuildContext context, int index, List<Map<String, dynamic>> goals, Function setState) {
    final goal = goals[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(goal['title']),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Deadline: ${goal['deadline']}"),
                const SizedBox(height: 10),
                const Text("Subtasks:", style: TextStyle(fontWeight: FontWeight.bold)),
                ...goal['subtasks'].map<Widget>((subtask) {
                  return StatefulBuilder(
                    builder: (context, subtaskSetState) {
                      return CheckboxListTile(
                        value: subtask['isChecked'],
                        onChanged: (value) {
                          subtaskSetState(() {
                            subtask['isChecked'] = value!;
                          });
                        },
                        title: Text(subtask['title']),
                        subtitle: Text("Deadline: ${subtask['deadline']}"),
                      );
                    },
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                editGoal(context, index, goals, setState);
              },
              child: const Text("Edit"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  goals.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}