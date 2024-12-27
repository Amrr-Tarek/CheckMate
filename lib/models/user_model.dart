import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String email;

  UserModel({required this.name, required this.email});

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    return UserModel(
      name: doc["name"],
      email: doc["email"],
    );
  }
}
