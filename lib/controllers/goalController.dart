import 'package:flutter/material.dart';
import 'package:checkmate/const/messages.dart';
import 'package:checkmate/models/buttons.dart'; // Import your custom Button widget

class GoalController {
  static const int Max_title_chars = 50;
  // Add a new goal to the state
  void addGoal(BuildContext context, List<Map<String, dynamic>> goals,
      Function setState) {
    final TextEditingController goalTitleController = TextEditingController();
    DateTime? goalDeadline;
    final TextEditingController subtaskTitleController =
        TextEditingController();
    DateTime? subtaskDeadline;
    List<Map<String, dynamic>> subtasks = [];
    String? errorMessage;
    int selectedSubtaskWeight = 1;
    int selectedGoalWeight = 1;

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
                    // Goal Title
                    TextField(
                      controller: goalTitleController,
                      decoration: const InputDecoration(
                        hintText: "Enter goal title",
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Goal Deadline
                    Row(
                      children: [
                        const Text("Select Deadline: "),
                        TextButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              dialogSetState(() {
                                goalDeadline = pickedDate;
                              });
                            }
                          },
                          child: Text(
                            goalDeadline == null
                                ? "Pick a Date"
                                : goalDeadline!
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Subtask Title
                    TextField(
                      controller: subtaskTitleController,
                      decoration: const InputDecoration(
                        hintText: "Enter subtask title",
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Subtask Deadline
                    Row(
                      children: [
                        const Text("Select Subtask Deadline: "),
                        TextButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              dialogSetState(() {
                                subtaskDeadline = pickedDate;
                              });
                            }
                          },
                          child: Text(
                            subtaskDeadline == null
                                ? "Pick a Date"
                                : subtaskDeadline!
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Subtask Weight
                    DropdownButton<int>(
                      value: selectedSubtaskWeight,
                      items: const [
                        DropdownMenuItem(child: Text("Low"), value: 1),
                        DropdownMenuItem(child: Text("Medium"), value: 2),
                        DropdownMenuItem(child: Text("High"), value: 3),
                      ],
                      onChanged: (int? newValue) {
                        dialogSetState(() {
                          selectedSubtaskWeight = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    // Add Subtask Button
                    TextButton(
                      onPressed: () {
                        final subtaskTitle = subtaskTitleController.text.trim();
                        dynamic subtaskGoalDeadline = goalDeadline;

                        // Validate Subtask
                        if (subtaskTitle.isEmpty || subtaskDeadline == null) {
                          dialogSetState(() {
                            errorMessage =
                                'Title and Deadline for subtask are required.';
                          });
                        } else if (subtaskGoalDeadline!
                            .isBefore(subtaskDeadline)) {
                          dialogSetState(() {
                            errorMessage =
                                'Subtask deadline cannot be before goal deadline.';
                          });
                        } else if (subtaskTitle.length > Max_title_chars) {
                          dialogSetState(() {
                            errorMessage =
                                'Subtask title exceeds maximum character limit.';
                          });
                        } else {
                          dialogSetState(() {
                            errorMessage = null;
                            subtasks.add({
                              'title': subtaskTitle,
                              'deadline': subtaskDeadline,
                              'weight': selectedSubtaskWeight,
                              'isChecked': false,
                            });
                          });
                          subtaskTitleController.clear();
                          subtaskDeadline = null;
                        }
                      },
                      child: const Text("Add Subtask"),
                    ),
                    const SizedBox(height: 10),
                    // Display Subtasks
                    Wrap(
                      spacing: 8.0,
                      children: subtasks.map((task) {
                        return Chip(
                          label: Text(
                            "${task['title']} - ${task['deadline']?.toLocal().toString().split(' ')[0] ?? 'No deadline'} (Weight: ${task['weight']})",
                          ),
                          onDeleted: () {
                            dialogSetState(() {
                              subtasks.remove(task);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    // Error Message
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

                    // Validate Goal
                    if (title.isEmpty || goalDeadline == null) {
                      dialogSetState(() {
                        errorMessage = 'Goal title and deadline are required.';
                      });
                    } else if (title.length > Max_title_chars) {
                      dialogSetState(() {
                        errorMessage =
                            'Goal title exceeds maximum character limit.';
                      });
                    } else {
                      setState(() {
                        goals.add({
                          'title': title,
                          'deadline': goalDeadline,
                          'subtasks': subtasks,
                          'weight': selectedGoalWeight,
                          'isChecked': false,
                          'score': 0.00,
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

void showGoalDetails(BuildContext context, int index,
    List<Map<String, dynamic>> goals, Function setState) {
  final goal = goals[index];
  final subtasks = List<Map<String, dynamic>>.from(goal['subtasks']); // Local copy

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter dialogSetState) {
          return AlertDialog(
            title: Text(goal['title']),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Deadline: ${goal['deadline']!.toLocal().toString().split(' ')[0]}"),
                  const SizedBox(height: 10),
                  const Text(
                    "Subtasks:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: subtasks.map((subtask) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Checkbox(
                              value: subtask['isChecked'],
                              onChanged: (value) {
                                dialogSetState(() {
                                  subtask['isChecked'] = value;
                                });
                                setState(() {
                                  // Immediately update the parent goal's subtasks
                                  goal['subtasks'] = subtasks;
                                  calculateGoalScore(goal);
                                });
                              },
                            ),
                            Expanded(
                              child: Text(
                                "${subtask['title']} - ${subtask['deadline']!.toLocal().toString().split(' ')[0]} (Weight: ${subtask['weight']})",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
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
                  setState(() {
                    goal['subtasks'] = subtasks; // Ensure final save
                    calculateGoalScore(goal);   // Update score
                  });
                },
                child: const Text("Save"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    goals.removeAt(index); // Remove the goal
                  });
                  Navigator.of(context).pop();
                },
                child: const Text("Delete"),
              ),
            ],
          );
        },
      );
    },
  );
}
  // Edit an existing goal
  void editGoal(BuildContext context, int index,
      List<Map<String, dynamic>> goals, Function setState) {
    final TextEditingController goalTitleController =
        TextEditingController(text: goals[index]['title']);
    DateTime? goalDeadline = goals[index]['deadline'];
    final TextEditingController subtaskTitleController =
        TextEditingController();
    DateTime? subtaskDeadline;
    List<Map<String, dynamic>> subtasks =
        List<Map<String, dynamic>>.from(goals[index]['subtasks']);
    String? errorMessage;
    int selectedSubtaskWeight = 1;
    int selectedGoalWeight = goals[index]['weight'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              title: const Text("Edit Goal"),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Goal Title Input
                    TextField(
                      controller: goalTitleController,
                      decoration:
                          const InputDecoration(hintText: "Edit goal title"),
                    ),
                    const SizedBox(height: 10),

                    // Goal Deadline Picker
                    Row(
                      children: [
                        const Text("Select Deadline: "),
                        TextButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: goalDeadline ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              dialogSetState(() {
                                goalDeadline = pickedDate;
                              });
                            }
                          },
                          child: Text(
                            goalDeadline == null
                                ? "Pick a Date"
                                : goalDeadline!
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Goal Weight Dropdown
                    DropdownButton<int>(
                      value: selectedGoalWeight,
                      items: const [
                        DropdownMenuItem(child: Text("Low"), value: 1),
                        DropdownMenuItem(child: Text("Medium"), value: 2),
                        DropdownMenuItem(child: Text("High"), value: 3),
                      ],
                      onChanged: (int? newValue) {
                        dialogSetState(() {
                          selectedGoalWeight = newValue!;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // Subtask Title Input
                    TextField(
                      controller: subtaskTitleController,
                      decoration: const InputDecoration(
                          hintText: "Enter subtask title"),
                    ),
                    const SizedBox(height: 10),

                    // Subtask Deadline Picker
                    Row(
                      children: [
                        const Text("Select Subtask Deadline: "),
                        TextButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: subtaskDeadline ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              dialogSetState(() {
                                subtaskDeadline = pickedDate;
                              });
                            }
                          },
                          child: Text(
                            subtaskDeadline == null
                                ? "Pick a Date"
                                : subtaskDeadline!
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Subtask Weight Dropdown
                    DropdownButton<int>(
                      value: selectedSubtaskWeight,
                      items: const [
                        DropdownMenuItem(child: Text("Low"), value: 1),
                        DropdownMenuItem(child: Text("Medium"), value: 2),
                        DropdownMenuItem(child: Text("High"), value: 3),
                      ],
                      onChanged: (int? newValue) {
                        dialogSetState(() {
                          selectedSubtaskWeight = newValue!;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    // Add Subtask Button
                    TextButton(
                      onPressed: () {
                        final subtaskTitle = subtaskTitleController.text.trim();
                        dynamic subtaskGoalDeadline = goalDeadline;
                        if (subtaskTitle.isEmpty || subtaskDeadline == null) {
                          dialogSetState(() {
                            errorMessage =
                                Messages.tittle_And_Deadline_Required;
                          });
                        } else if (subtaskGoalDeadline!
                            .isBefore(subtaskDeadline)) {
                          dialogSetState(() {
                            errorMessage =
                                Messages.subtask_deadline_before_goal_deadline;
                          });
                        } else if (subtaskTitle.length > Max_title_chars) {
                          dialogSetState(() {
                            errorMessage =
                                Messages.exceedCharLimit(Max_title_chars);
                          });
                        } else {
                          dialogSetState(() {
                            errorMessage = null;
                            subtasks.add({
                              'title': subtaskTitle,
                              'deadline': subtaskDeadline,
                              'weight': selectedSubtaskWeight,
                              'isChecked': false,
                            });
                          });
                        }
                      },
                      child: const Text("Add Subtask"),
                    ),

                    // Display Subtasks
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 8.0,
                        children: subtasks.map((task) {
                          return Chip(
                            label: Text(
                                "${task['title']} - ${task['deadline'].toLocal().toString().split(' ')[0]} (Weight: ${task['weight']})"),
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
                // Cancel Button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),

                // Save Button
                TextButton(
                  onPressed: () {
                    final title = goalTitleController.text.trim();

                    if (title.isEmpty || goalDeadline == null) {
                      dialogSetState(() {
                        errorMessage = "Goal title and deadline are required.";
                      });
                    } else {
                      setState(() {
                        goals[index] = {
                          'title': title,
                          'deadline': goalDeadline,
                          'subtasks': subtasks,
                          'weight': selectedGoalWeight,
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

double calculateGoalScore(Map<String, dynamic> goal) {
  final deadline = goal['deadline'] as DateTime;
  final subtasks = goal['subtasks'] as List<Map<String, dynamic>>;
  final isGoalChecked = goal['isChecked'] as bool;

  // Early return if no subtasks exist
  if (subtasks.isEmpty) {
    if (isGoalChecked && deadline.isAfter(DateTime.now())) {
      return 100.0; // Goal completed on time with no subtasks
    } else if (isGoalChecked) {
      return 80.0; // Goal completed, but after the deadline
    } else {
      return 50.0; // Goal not completed, and no subtasks to evaluate
    }
  }

  int totalWeight = 0;
  int completedWeight = 0;

  bool allSubtasksChecked = true;
  bool allSubtasksBeforeDeadline = true;

  // Calculate weights and check conditions for subtasks
  for (var subtask in subtasks) {
    final isChecked = subtask['isChecked'] as bool;
    final subtaskDeadline = subtask['deadline'] as DateTime;
    final weight = subtask['weight'] as int;

    totalWeight += weight;
    if (isChecked) {
      completedWeight += weight;
    } else {
      allSubtasksChecked = false;
    }

    if (subtaskDeadline.isAfter(deadline)) {
      allSubtasksBeforeDeadline = false;
    }
  }

  // Base score logic
  double score = 100.0;

  // Apply penalties based on the conditions
  if (!isGoalChecked) {
    // Goal is not completed
    score -= 20.0; // Penalty for not finishing the goal
  }

  if (!allSubtasksChecked) {
    // Some subtasks are not completed
    score -= (20.0 * (1 - (completedWeight / totalWeight))); // Penalty based on incomplete subtask weights
  }

  if (isGoalChecked && !allSubtasksChecked) {
    // Goal is completed, but not all subtasks are
    score -= 15.0; // Additional penalty
  }

  if (!allSubtasksBeforeDeadline) {
    // Some subtasks were completed after the deadline
    score -= 10.0; // Penalty for not meeting the deadline
  }

  if (isGoalChecked && allSubtasksChecked && deadline.isBefore(DateTime.now())) {
    // All completed but after the goal deadline
    score -= 10.0; // Penalty for late goal completion
  }

  // Ensure score is between 0 and 100
  return score.clamp(0.0, 100.0);
}

}