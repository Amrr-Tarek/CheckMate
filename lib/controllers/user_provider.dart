import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel _user = UserModel(name: "", email: "", xp: 0);

  UserModel get user => _user; // Getter

  void setUser(UserModel user) {
    _user = user;
    notifyListeners(); // Notify listeners to rebuild when data changes
  }

  void clearUser() {
    _user = UserModel(name: "", email: "", xp: 0);
    notifyListeners(); // Notify listeners to rebuild when data changes
  }

  Future<void> fetchUserData(String userId) async {
    // Fetch user data from Firestore
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();
      if (userDoc.exists) {
        _user = UserModel(
          name: userDoc["name"],
          email: userDoc["email"],
          xp: userDoc["xp"],
        );
        notifyListeners();
      } else {
        print("User not found.");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }
}
