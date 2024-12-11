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
  List<Map<String, dynamic>> tasks = []; // List to store tasks and their checked states

  // Function to add a routine (task)
  void _addRoutine() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController taskController = TextEditingController();

        return AlertDialog(
          title: const Text("Add New Task"),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(
              hintText: "Enter task description",
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
                if (taskController.text.isNotEmpty) {
                  setState(() {
                    tasks.add({
                      'text': taskController.text,
                      'isChecked': false,
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Add Task"),
            ),
          ],
        );
      },
    );
  }

  // Function to remove a task
  void _removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Separate tasks into checked and unchecked
    List<Map<String, dynamic>> checkedTasks = tasks.where((task) => task['isChecked']).toList();
    List<Map<String, dynamic>> uncheckedTasks = tasks.where((task) => !task['isChecked']).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Routine Page")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [          
          // Dynamic ListView for unchecked tasks
          if (uncheckedTasks.isNotEmpty)
            Flexible(
              child: ListView.builder(
                shrinkWrap: true, // This makes the ListView take only the space it needs
                itemCount: uncheckedTasks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: CheckBoxWidget(
                            isChecked: uncheckedTasks[index]['isChecked'],
                            onChanged: (newState) {
                              setState(() {
                                uncheckedTasks[index]['isChecked'] = newState;
                              });
                            },
                            text: Text(
                              uncheckedTasks[index]['text'],
                              style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _removeTask(index); // Remove task when delete icon is pressed
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          // If no unchecked tasks, show a message
          if (uncheckedTasks.isEmpty && ! checkedTasks.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: const Text(
                Messages.finishTasks,
                style: TextStyle(
                  fontSize: 32,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold
                ),
              ),
            )
            else if (uncheckedTasks.isEmpty && checkedTasks.isEmpty)
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: const Text(
                Messages.motivationToAddTasks,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          
          // ListView to display checked tasks
          if (checkedTasks.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: checkedTasks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: CheckBoxWidget(
                            isChecked: checkedTasks[index]['isChecked'],
                            onChanged: (newState) {
                              setState(() {
                                checkedTasks[index]['isChecked'] = newState;
                              });
                            },
                            text: Text(
                              checkedTasks[index]['text'],
                              style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _removeTask(index); // Remove task when delete icon is pressed
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

        ],
      ),
      
      // Floating action button for adding a new task
      floatingActionButton: FloatingActionButton(
        onPressed: _addRoutine, // Call _addRoutine to open the dialog
        child: const Icon(Icons.add), // "+" icon for adding a task
      ),
    );
  }
}