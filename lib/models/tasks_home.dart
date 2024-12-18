import 'package:flutter/material.dart';

/// A model file to handle tasks to eliminate redundancy

class TaskModel {
  final String taskName;
  final Color color;

  const TaskModel({
    required this.taskName,
    required this.color,
  });

  static List<TaskModel> getTasks() {
    // Assume data is queried
    List<TaskModel> myTasks = [];

    myTasks.add(TaskModel(taskName: "Task1", color: Colors.black));
    myTasks.add(TaskModel(taskName: "Task2", color: Colors.red));
    myTasks.add(TaskModel(taskName: "Task3", color: Colors.blue));
    myTasks.add(TaskModel(taskName: "Task4", color: Colors.green));

    return myTasks;
  }
}
