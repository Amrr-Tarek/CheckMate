// import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String email;
  int xp;

  UserModel({required this.name, required this.email, required this.xp});

  // factory UserModel.fromFirestore(DocumentSnapshot doc) {
  //   return UserModel(
  //     name: doc["name"],
  //     email: doc["email"],
  //     xp: doc["xp"],
  //   );
  // }
}
