import 'package:checkmate/controllers/user_provider.dart';
import 'package:checkmate/models/calendar_model.dart';
import 'package:checkmate/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
// ignore: depend_on_referenced_packages
import 'package:checkmate/pages/calendar.dart';
// import 'calendar_provider.dart';

/// This file contains the FirestoreDataSource class which is responsible for all the CRUD operations in the Firestore database.
class EventData {
  final String id;
  final String title;
  final DateTime day;

  EventData({required this.id, required this.title, required this.day});
}

class FirestoreDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createUser(String name, String email) async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        "id": _auth.currentUser!.uid,
        "email": email.toLowerCase(),
        "name": name,
        "xp": 0,
      });
      print("===============================================");
      print(_auth.currentUser!.uid);
      return true;
    } catch (e) {
      return true;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      final DocumentReference userDoc =
          _firestore.collection("users").doc(userId);

      // Delete subcollections
      final subcollections = await userDoc.collection("routine").get();
      for (var doc in subcollections.docs) {
        await doc.reference.delete();
      }

      // Delete main document
      await userDoc.delete();
      print("User $userId deleted successfully.");
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  // Updates the name of the user in the Firestore database
  Future<void> updateName(String name, BuildContext context) async {
    try {
      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .update({"name": name});

      // Fetching the user's name for extra security
      final userDoc = await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .get();
      if (userDoc.exists) {
        context.read<UserProvider>().setUser(UserModel(
              name: userDoc.data()!["name"],
              email: userDoc.data()!["email"],
              xp: userDoc.data()!["xp"],
            ));
      }
    } catch (e) {
      print("Error updating name: $e");
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

  // =========================================================================
  // Calebdar database manuplation

  // add event to the calendar
  String createDocId() {
    String docId = Uuid().v4();
    return docId;
  }

  Future<void> addCalendarEvent(String eventName, DateTime eventDay) async {
    try {
      // i
      String docId = createDocId();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('calendar')
          .doc(docId)
          .set({
        'id': docId,
        'event': eventName,
        'day': eventDay,
      });
      // return true;
    } catch (e) {
      print("Exception: $e");
      // return true;
    }
  }

  // ------------------------------------------------------------------------
  Future<String?> getDocId(String eventName, DateTime eventDay) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('calendar')
          .where('event', isEqualTo: eventName)
          .where('day', isEqualTo: eventDay)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs[0].id;
      } else {
        print("No document found for the given event and day.");
        return null;
      }
    } catch (e) {
      print("Couldn't resolve document ID: $e");
      return null;
    }
  }

  Future<void> deleteCalendarEvent(String eventId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('calendar')
          .doc(eventId)
          .delete();
      print("Event with ID $eventId deleted successfully.");
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<List<EventModel>> getEvents() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('calendar')
          .get();

      return querySnapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
    } catch (e) {
      print("Error fetching events: $e");
      return [];
    }
  }



  Future<bool> removeRoutine({required String routine_id}) async {
    try {
      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("routine")
          .doc(routine_id)
          .delete();
      return true;
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAllRoutines() async {
    try {
      var snapshot = await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("routine")
          .get();

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

      // Create the goal document
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
        'weight': weight,
        'isChecked': false,
        'score': 0.00,
      });

      // Add each subtask as a separate document inside the 'subtasks' subcollection
      for (var subtask in subtasks) {
        var uuids =
          Uuid().v4();
        // Assuming each subtask is a map containing the necessary data (like 'taskName' or 'status')
        await _firestore
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .collection("goals")
            .doc(uuids)
            .collection("subtasks")
            .add(subtask); // Add each subtask as a document
      }

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
      // Update goal document fields
      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("goals")
          .doc(goal_id)
          .update({
        'title': title,
        'deadline': deadline,
        'weight': weight,
        'isChecked': isChecked,
        'score': score,
      });

      // Update each subtask document in the subtasks subcollection
      for (var subtask in subtasks) {
        // Assuming each subtask has a unique ID, you may need to provide the ID for each subtask
        var subtaskId =
            subtask['id']; // You should have an 'id' for each subtask
        await _firestore
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .collection("goals")
            .doc(goal_id)
            .collection("subtasks")
            .doc(subtaskId) // Update the specific subtask document by its ID
            .update(subtask);
      }

      return true;
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }

  Future<bool> updateGoal(String goal_id, List<Map<String, dynamic>> subtasks,
      bool isChecked, double score) async {
    try {
      // Reference to the goal document
      var goalDocRef = _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("goals")
          .doc(goal_id);

      // Reference to the subtasks subcollection
      var subtasksCollectionRef = goalDocRef.collection("subtasks");

      // Delete all existing subtasks
      var snapshot = await subtasksCollectionRef.get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // Add new subtasks
      for (var subtask in subtasks) {
        await subtasksCollectionRef.add(subtask);
      }

      // Update the goal document with the new subtasks and other fields
      await goalDocRef.update({
        'subtasks': subtasks, // Update the subtasks field in the goal document
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
          .delete();
      return true;
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAllGoals() async {
    try {
      var snapshot = await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("goals")
          .get();

      List<Map<String, dynamic>> goals = [];
      for (var doc in snapshot.docs) {
        var data = doc.data();

        // Ensure the 'subtasks' field is treated as a List<Map<String, dynamic>> if it exists
        if (data['subtasks'] != null && data['subtasks'] is List) {
          // Convert subtasks into List<Map<String, dynamic>> if it's a list
          data['subtasks'] = (data['subtasks'] as List).map((subtask) {
            if (subtask is Map) {
              var subtaskMap = Map<String, dynamic>.from(subtask);

              // Convert the deadline to a DateTime if it's a Timestamp
              if (subtaskMap['deadline'] is Timestamp) {
                subtaskMap['deadline'] =
                    (subtaskMap['deadline'] as Timestamp).toDate();
              }
              return subtaskMap;
            }
            return {}; // Return an empty map for invalid entries
          }).toList();
        }

        // Fetch subtasks from the subcollection "subtasks" in the goal document if available
        var subtasksSnapshot = await _firestore
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .collection("goals")
            .doc(doc.id)
            .collection("subtasks")
            .get();

        List<Map<String, dynamic>> subtasks = [];
        for (var subtaskDoc in subtasksSnapshot.docs) {
          var subtaskData = subtaskDoc.data();

          // Convert subtask fields (e.g., deadline) if necessary
          if (subtaskData['deadline'] is Timestamp) {
            subtaskData['deadline'] =
                (subtaskData['deadline'] as Timestamp).toDate();
          }

          // Add subtask to the list
          subtasks.add(Map<String, dynamic>.from(subtaskData));
        }

        // Merge goal data with the fetched subtasks
        data['subtasks'] = subtasks;

        // Convert the deadline to DateTime if it's a Timestamp in the goal document
        if (data['deadline'] is Timestamp) {
          data['deadline'] = (data['deadline'] as Timestamp).toDate();
        }

        // Add the goal to the list
        goals.add(Map<String, dynamic>.from(data));
      }

      return goals;
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getUncheckedGoals() async {
    try {
      var snapshot = await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("goals")
          .where("isChecked", isEqualTo: false)
          .get();

      List<Map<String, dynamic>> uncheckedGoals = [];
      for (var doc in snapshot.docs) {
        var data = doc.data();

        if (data['deadline'] is Timestamp) {
          data['deadline'] = (data['deadline'] as Timestamp).toDate();
        }

        uncheckedGoals.add({
          "title": data["title"] ?? "",
          "deadline": data["deadline"] ?? null,
          "weight": data["wieght"],
        });
      }
      return uncheckedGoals;
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }
}
