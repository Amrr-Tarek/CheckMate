import 'package:checkmate/controllers/firestore_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// This file contains the AuthController class, which is responsible for handling user authentication.
/// Register, Login, and Logout functions are defined in this class.

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

  Future<void> signInWithGoogle({required BuildContext context}) async {
    try {
      // Sign in with Google
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) return;

      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      // Create new credential for user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Extract user Info
      final User? user = userCredential.user;
      if (user != null) {
        final String name = user.displayName ?? "Unknown User";
        final String email = user.email ?? "Blank Email";

        FirestoreDataSource().createUser(name, email);
      }

      Navigator.pushReplacementNamed(context, "/home");
    } catch (e) {
      print("Exception $e");
    }
  }

  Future<UserCredential?> signInWithGithub(
      {required BuildContext context}) async {
    try {
      // Sign in with Github
      GithubAuthProvider githubAuthProvider = GithubAuthProvider();
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithProvider(githubAuthProvider);

      // Extract user Info
      final User? user = userCredential.user;
      if (user != null) {
        final String name = user.displayName ?? "Unknown User";
        final String email = user.email ?? "Blank Email";

        FirestoreDataSource().createUser(name, email);
      }
      Navigator.pushReplacementNamed(context, "/home");
      return userCredential;
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  Future<void> signOut() async {}
}
