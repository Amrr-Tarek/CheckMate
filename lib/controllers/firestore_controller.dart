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

  Future<bool> addRoutine(String title, int duration) async {
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
        "title": title,
        "duration": duration,
        "time": data,
        "isDone": false,
      });
      return true;
    } catch (e) {
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

  // // GET THE ID OF DOC
  // Future<String> getDocId(String eventName, DateTime eventDay) async {
  //   try {
  //     String docId = createDocId();
  //     final docSnapShot = await _firestore
  //         .collection('users')
  //         .doc(_auth.currentUser!.uid)
  //         .collection('calendar')
  //         .where('event', isEqualTo: eventName)
  //         .where('day', isEqualTo: eventDay)
  //         .get();
  //     return docSnapShot.docs[0].id;
  //   } catch (e) {
  //     print("Couldn't resolve name $e");
  //     return "FAIL";
  //   }
  // }
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

  // delete event from the calendar
  // Future<void> deleteCalendarEvent(String id) async {
  //   try {
  //     // print(id);
  //     await final collectionRef _firestore
  //         .collection('users')
  //         .doc(_auth.currentUser!.uid)
  //         .collection('calendar');
  //         final querySnapshot = await collectionRef.get();
  //   for (var doc in querySnapshot.docs) {
  //     await doc.reference.delete();
  //   }
  //   print("All calendar events deleted successfully.");
  //   } catch (e) {
  //     print("Exception: $e");
  //   }
  // }
//   Future<void> deleteAllCalendarEvents(String id) async {
//   try {
//     await _firestore
//         .collection('users')
//         .doc(_auth.currentUser!.uid)
//         .collection('calendar')
//         .where('id', isEqualTo: id)
//         .get()
//         .then((querySnapshot) {
//           for (var doc in querySnapshot.docs) {
//             doc.reference.delete();
//           }
//         });

//     // final querySnapshot = await collectionRef.get();
//     // for (var doc in querySnapshot.docs) {
//     //   // if (doc.id == docSnapShot.docs[0].id) {
//     //   //   continue;
//     //   // }
//     //   await doc.reference.delete();
//     // }
//     print("All calendar events deleted successfully.");
//   } catch (e) {
//     print("Exception: $e");
//   }
// }

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

// ==============================================================
// Future<void> addGoals(String eventName, DateTime eventDay) async {
//     try {

//       String docId = createDocId();
//       await _firestore
//           .collection('users')
//           .doc(_auth.currentUser!.uid)
//           .collection('calendar')
//           .doc(docId)
//           .set({
//             'id': docId,
//         'event': eventName,
//         'day': eventDay,
//       });
//     } catch (e) {
//       print("Exception: $e");
//     }
// }

// =========================================

// Future<Map<String, List<Event>>> getCalendarEvents() async {
//   try {
//     final querySnapshot = await _firestore
//         .collection('users')
//         .doc(_auth.currentUser!.uid)
//         .collection('calendar')
//         .get();

//     Map<String, List<Event>> eventsDB = {};
//     for (var doc in querySnapshot.docs) {
//       // CREATE EVENT OBJECT
//       final event = Event(
//         id: doc['id'],
//         title: doc['event'],
//         day: (doc['day'] as Timestamp).toDate(),
//       );
//       eventsDB[doc.id] = event as List<Event>;
//       // );

//       // final key = "${event.day.year}-${event.day.month}-${event.day.day}";
//       // if (events.containsKey(key)) {
//       //   events[key]!.add(event);
//       // } else {
//       //   events[key] = [event];
//       // }
//     }
//     return eventsDB;
//   } catch (e) {
//     print("Exception: $e");
//     return {};
//   }
// }
  // Future<Map<String, EventData>> getCalendarEvents() async {
  //   try {
  //     final querySnapshot = await _firestore
  //         .collection('users')
  //         .doc(_auth.currentUser!.uid)
  //         .collection('calendar')
  //         .get();

  //     Map<String, EventData> eventsDB = {};
  //     for (var doc in querySnapshot.docs) {
  //       // CREATE EVENT OBJECT
  //       final event = EventData(
  //         id: doc['id'],
  //         title: doc['event'],
  //         day: (doc['day'] as Timestamp).toDate(),
  //       );

  //       // Use the document ID as the key
  //       eventsDB[doc.id] = event;
  //     }
  //     return eventsDB;
  //   } catch (e) {
  //     print("Exception: $e");
  //     return {};
  //   }
  // }

// ==========================================================
// the last trial to fetch the data
  // Future<String?> getEventByNameAndDate(DateTime eventDay) async {
  //   try {
  //     final docSnapshot = await _firestore
  //         .collection('users')
  //         .doc(_auth.currentUser!.uid)
  //         .collection('calendar')
  //         // .where('event', isEqualTo: eventName)
  //         .where('day', isEqualTo: eventDay)
  //         .get();

  //     if (docSnapshot.docs.isNotEmpty) {
  //       if (docSnapshot.docs.isNotEmpty) {
  //         return docSnapshot.docs[0]['event'];
  //       } else {
  //         print("No event found with the given criteria.");
  //         return null;
  //       }
  //     } else {
  //       print("No event found with the given criteria.");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Couldn't fetch event: $e");
  //     return null;
  //   }
  // }
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


}
