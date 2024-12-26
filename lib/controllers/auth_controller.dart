/// This file contains the AuthController class, which is responsible for handling user authentication.
/// Register, Login, and Logout functions are defined in this class.

import 'package:checkmate/controllers/firestore_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // Future<User?> signInWithEmail(String email, String password) async {
  //   try {
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return userCredential.user;
  //   } catch (e) {
  //     print("Error signing in: $e");
  //     return null;
  //   }
  // }
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    print("===============================================");
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        FirestoreDataSource().createUser(name, email);
      });
    } on FirebaseAuthException catch (e) {
      String message = "empty-message";
      if (e.code == "weak-password") {
        message = "The password provided is too weak!";
      } else if (e.code == "email-already-in-use") {
        message = "Email already in use!";
      } else {
        message = "Error: ${e.code}";
      }
      print("#######################3");
      print(email);
      print(password);
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.blue[600],
        textColor: Colors.white,
        fontSize: 20.0,
      );
    } catch (e) {
      print("Error signing up: $e");
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    print("===============================================");
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacementNamed(context, "/home");
    } on FirebaseAuthException catch (e) {
      String message = "empty-message";
      message = "Error: ${e.code}";
      print("#######################3");
      print(email);
      print(password);
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.blue[600],
        textColor: Colors.white,
        fontSize: 20.0,
      );
    } catch (e) {
      print("Error signing up: $e");
    }
  }

  Future<void> signOut() async {}
}
