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

  Future<bool> addRoutine(String title, int duration) async {
    try {
      var uuid = Uuid().v4(); // Creates a unique id for the collection (Primary Key)
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
}
