import 'package:flutter/material.dart';
import 'package:checkmate/const/messages.dart';
import 'package:checkmate/controllers/firestore_controller.dart';

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
                    const SizedBox(height: 10),
                    // Subtask Section
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

                        if (subtaskTitle.isEmpty || subtaskDeadline == null) {
                          dialogSetState(() {
                            errorMessage =
                                Messages.tittle_And_Deadline_Required;
                          });
                        } else {
                          dialogSetState(() {
                            subtasks.add({
                              'title': subtaskTitle,
                              'deadline': subtaskDeadline,
                              'weight': selectedSubtaskWeight,
                              'isChecked': false,
                            });
                            subtaskTitleController.clear();
                            subtaskDeadline = null;
                            errorMessage = null;
                          });
                        }
                      },
                      child: const Text("Add Subtask"),
                    ),
                    // Subtasks Display
                    Wrap(
                      spacing: 8.0,
                      children: subtasks.map((task) {
                        return Chip(
                          label: Text(
                            "${task['title']} - ${task['deadline']?.toLocal().toString().split(' ')[0] ?? 'No deadline'}",
                          ),
                          onDeleted: () {
                            dialogSetState(() {
                              subtasks.remove(task);
                            });
                          },
                        );
                      }).toList(),
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
                  onPressed: () async {
                    final title = goalTitleController.text.trim();
                    if (title.isEmpty || goalDeadline == null) {
                      dialogSetState(() {
                        errorMessage = Messages.tittle_And_Deadline_Required;
                      });
                    } else {
                      final id = await FirestoreDataSource().addgoal(
                        title,
                        goalDeadline!,
                        subtasks,
                        selectedGoalWeight,
                      );

                      if (id != null) {
                        setState(() {
                          goals.add({
                            'id': id,
                            'title': title,
                            'deadline': goalDeadline,
                            'subtasks': subtasks,
                            'weight': selectedGoalWeight,
                            'isChecked': false,
                            'score': 0.00,
                          });
                        });
                        Navigator.of(context).pop();
                      } else {
                        dialogSetState(() {
                          errorMessage = 'Failed to add the goal.';
                        });
                      }
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

  void showGoalDetails(
    BuildContext context,
    int index,
    List<Map<String, dynamic>> goals,
    Function setState,
  ) {
    final goal = goals[index];
    final List<Map<String, dynamic>> subtasks = goal['subtasks']; // Local copy

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
                    Text(
                      "Deadline: ${goal['deadline']!.toLocal().toString().split(' ')[0]}",
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Subtasks:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: subtasks.map((subtask) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Checkbox(
                                value: subtask['isChecked'],
                                onChanged: (value) async {
                                  dialogSetState(() {
                                    subtask['isChecked'] =
                                        value; // Update local subtask state
                                  });

                                  // Update parent goal's subtasks and recalculate score
                                  setState(() {
                                    goal['subtasks'] = subtasks;
                                    goal['score'] = calculateGoalScore(goal);
                                    goal['isChecked'] = subtasks.every((st) => st[
                                        'isChecked']); // Update goal's finished status
                                  });

                                  // Sync updates to Firestore
                                  final success =
                                      await FirestoreDataSource().updateGoal(
                                    goal['id'],
                                    subtasks,
                                    goal['isChecked'],
                                    goal['score'],
                                  );

                                  if (!success) {
                                    dialogSetState(() {
                                      subtask['isChecked'] = value == true
                                          ? false
                                          : true; // Rollback on failure
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Failed to update subtask."),
                                      ),
                                    );
                                  }
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
                    editGoal(
                        context, index, goals, setState); // Navigate to edit
                  },
                  child: const Text("Edit"),
                ),
                TextButton(
                  onPressed: () async {
                    final success = await FirestoreDataSource().removeGoal(
                      goal_id: goal['id'],
                    );
                    if (success) {
                      setState(() {
                        goals.removeAt(index); // Remove goal locally
                      });
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Failed to delete goal."),
                        ),
                      );
                    }
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
    List<Map<String, dynamic>> subtasks = goals[index]['subtasks'];
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
                  onPressed: () async {
                    final title = goalTitleController.text.trim();

                    if (title.isEmpty || goalDeadline == null) {
                      dialogSetState(() {
                        errorMessage = "Goal title and deadline are required.";
                      });
                    } else {
                      final goalId = goals[index]['id'];
                      final success = await FirestoreDataSource().editgoal(
                        goalId,
                        title,
                        goalDeadline!,
                        subtasks,
                        selectedGoalWeight,
                        goals[index]['isChecked'],
                        goals[index]['score'],
                      );

                      if (success) {
                        setState(() {
                          goals[index] = {
                            'id': goalId,
                            'title': title,
                            'deadline': goalDeadline,
                            'subtasks': subtasks,
                            'weight': selectedGoalWeight,
                            'isChecked': goals[index]['isChecked'],
                            'score': goals[index]['score'],
                          };
                        });
                        Navigator.of(context).pop();
                      } else {
                        dialogSetState(() {
                          errorMessage =
                              "Failed to update the goal. Please try again.";
                        });
                      }
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
    final List<Map<String, dynamic>> subtasks = goal['subtasks'];
    final isGoalChecked = goal['isChecked'] as bool;

    // Early return if no subtasks exist
    if (subtasks.isEmpty) {
      if (isGoalChecked && deadline.isAfter(DateTime.now())) {
        return 100.0; // Goal completed on time with no subtasks
      } else if (isGoalChecked) {
        return 80.0; // Goal completed, but after the deadline
      } else {
        return 0.0; // Goal not completed, and no subtasks to evaluate
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
      // Apply stronger penalty when goal is also unchecked
      score -= (20.0 *
          (1 -
              (completedWeight /
                  totalWeight))); // Penalty based on incomplete subtask weights
    }

    if (isGoalChecked && !allSubtasksChecked) {
      // Goal is completed, but not all subtasks are
      score -= 15.0; // Additional penalty
    }

    if (!allSubtasksBeforeDeadline) {
      // Some subtasks were completed after the deadline
      score -= 10.0; // Penalty for not meeting the deadline
    }

    if (isGoalChecked &&
        allSubtasksChecked &&
        deadline.isBefore(DateTime.now())) {
      // All completed but after the goal deadline
      score -= 10.0; // Penalty for late goal completion
    }

    // Stronger penalty if no tasks and goal are unchecked
    if (!isGoalChecked && completedWeight == 0) {
      score =
          0.0; // Ensure score is 0 when neither the goal nor subtasks are completed
    }

    // Ensure score is between 0 and 100
    return score.clamp(0.0, 100.0);
  }

  String getWeightLabel(int weight) {
    switch (weight) {
      case 1:
        return "Low";
      case 2:
        return "Medium";
      case 3:
        return "High";
      default:
        return "Unknown"; // In case there's an unexpected value
    }
  }
}
