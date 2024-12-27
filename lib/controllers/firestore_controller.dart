/// This file contains the FirestoreDataSource class which is responsible for all the CRUD operations in the Firestore database.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FirestoreDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createUser(String name, String email) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set({"id": _auth.currentUser!.uid, "email": email, "name": name});
      print("===============================================");
      print(_auth.currentUser!.uid);
      return true;
    } catch (e) {
      return true;
    }
  }

  Future<String> getName() async {
    try {
      final docSnapShot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      return await docSnapShot.data()!["name"];
    } catch (e) {
      print("Couldn't resolve name $e");
      return "FAIL";
    }
  }

  Future<String?> addRoutine(String title, int duration) async {
    try {
      var uuid =
          Uuid().v4(); // Creates a unique id for the collection (Primary Key)
      DateTime data = DateTime.now();
      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("routine")
          .doc(uuid)
          .set({
        "id": uuid,
        "text": title,
        "interval": duration,
        "time": data,
        "isChecked": false,
      });
      return uuid;
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  Future<bool> editRoutine({
    required String routine_id,
    required String title,
    required int duration,
  }) async {
    try {
      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("routine")
          .doc(routine_id)
          .update({
        "text": title,
        "interval": duration,
      });
      return true;
    } catch (e) {
      print(_firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("routine")
          .doc(routine_id)
          .path);
      print("Exception: $e");
      return false;
    }
  }

  Future<bool> CheckRoutine(
      {required String routine_id, bool check_uncheck = true}) async {
    try {
      if (check_uncheck) {
        await _firestore
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .collection("routine")
            .doc(routine_id)
            .update({
          "isChecked": true,
        });
      } else {
        await _firestore
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .collection("routine")
            .doc(routine_id)
            .update({
          "isChecked": false,
        });
      }

      return true;
    } catch (e) {
      print(routine_id);
      print("Exception: $e");
      return true;
    }
  }

  Future<bool> removeRoutine({required String routine_id}) async {
    try {
      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("routine")
          .doc(routine_id)
          .delete(); // Deletes the document
      return true;
    } catch (e) {
      print("Exception: $e");
      return false; // Return false in case of error
    }
  }

  Future<List<Map<String, dynamic>>> getAllRoutines() async {
    try {
      var snapshot = await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("routine")
          .get(); // Gets all documents in the "routine" collection for the user

      List<Map<String, dynamic>> routines = [];
      for (var doc in snapshot.docs) {
        routines.add(doc.data());
      }
      return routines; // Returns a list of routine data
    } catch (e) {
      print("Exception: $e");
      return []; // Returns an empty list if there's an error
    }
  }

  Future<String?> addgoal(String title, DateTime deadline,
      List<Map<String, dynamic>> subtasks, int weight) async {
    try {
      DateTime date = DateTime.now();
      var uuid =
          Uuid().v4(); // Creates a unique id for the collection (Primary Key)
      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("goals")
          .doc(uuid)
          .set({
        'id': uuid,
        'date': date,
        'title': title,
        'deadline': deadline,
        'subtasks': subtasks,
        'weight': weight, // Add the selected goal weight
        'isChecked': false,
        'score': 0.00,
      });
      return uuid;
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  Future<bool> editgoal(
      String goal_id,
      String title,
      DateTime deadline,
      List<Map<String, dynamic>> subtasks,
      int weight,
      bool isChecked,
      double score) async {
    try {
      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("goals")
          .doc(goal_id)
          .update({
        'title': title,
        'deadline': deadline,
        'subtasks': subtasks,
        'weight': weight, // Add the selected goal weight
      });
      return true;
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }

  Future<bool> update_goal(String goal_id, List<Map<String, dynamic>> subtasks,
      bool isChecked, double score) async {
    try {
      DateTime data = DateTime.now();
      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("goals")
          .doc(goal_id)
          .update({
        'subtasks': subtasks,
        'isChecked': isChecked,
        'score': score,
      });
      return true;
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }

  Future<bool> removeGoal({required String goal_id}) async {
    try {
      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("goals")
          .doc(goal_id)
          .delete(); // Deletes the document
      return true;
    } catch (e) {
      print("Exception: $e");
      return false; // Return false in case of error
    }
  }

Future<List<Map<String, dynamic>>> getAllGoals() async {
  try {
    var snapshot = await _firestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("goals")
        .get(); // Gets all documents in the "goals" collection for the user

    List<Map<String, dynamic>> goals = [];
    for (var doc in snapshot.docs) {
      var data = doc.data();

      // Ensure the 'subtasks' field is treated as a List<Map<String, dynamic>> if it exists
      if (data['subtasks'] != null && data['subtasks'] is List) {
        // Explicitly cast each subtask to Map<String, dynamic>
        data['subtasks'] = (data['subtasks'] as List).map((e) {
          if (e is Map) {
            // Cast the Map<dynamic, dynamic> to Map<String, dynamic>
            return Map<String, dynamic>.from(e);
          } else {
            return {}; // Return an empty map if it's not a Map<String, dynamic>
          }
        }).toList();
      }

      // Ensure the data is a Map<String, dynamic>
      goals.add(Map<String, dynamic>.from(data));
    }
    return goals; // Returns a list of goal data
  } catch (e) {
    print("Exception: $e");
    return []; // Returns an empty list if there's an error
  }
}
}
