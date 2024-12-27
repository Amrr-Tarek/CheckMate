import 'package:checkmate/controllers/firestore_controller.dart';
import 'package:checkmate/controllers/user_provider.dart';
import 'package:checkmate/models/toast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

/// Handles user authentication, including email/password, Google, and GitHub sign-in methods.
/// Provides methods for registration, login (+ google and github), and logout.

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance; // DRY

  /// Registers a new user with email and password, and stores their data in Firestore database.
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirestoreDataSource().createUser(name, email);
      showToast("Sign-up successful! Welcome, $name.", Colors.green);
      Navigator.pushReplacementNamed(context, "/home");
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      print("Error signing up: $e");
    }
  }

  /// Signs in a user with email and password.
  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = _auth.currentUser!.uid;
      await Provider.of<UserProvider>(context, listen: false)
          .fetchUserData(uid);
      Navigator.pushReplacementNamed(context, "/home");
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      print("Error signing in: $e");
    }
  }

  /// Signs in a user with Google, extracts their details, and stores their data in Firestore.
  Future<void> signInWithGoogle({required BuildContext context}) async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) return; // User canceled sign-in

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      _saveUserToFirestore(userCredential);
      Navigator.pushReplacementNamed(context, "/home");
    } catch (e) {
      print("Error during Google Sign-In: $e");
    }
  }

  /// Signs in a user with GitHub, extracts their details, and stores their data in Firestore.
  Future<UserCredential?> signInWithGithub(
      {required BuildContext context}) async {
    try {
      final GithubAuthProvider githubAuthProvider = GithubAuthProvider();
      final UserCredential userCredential =
          await _auth.signInWithProvider(githubAuthProvider);

      _saveUserToFirestore(userCredential);
      Navigator.pushReplacementNamed(context, "/home");
      return userCredential;
    } catch (e) {
      print("Error during GitHub Sign-In: $e");
      return null;
    }
  }

  /// Signs out the currently signed-in user.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      showToast("Successfully signed out.", Colors.green);
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  Future<void> deleteAccount({required BuildContext context}) async {
    print(context);
    final User? user = _auth.currentUser;
    if (user == null) {
      showToast("No user is signed in!", Colors.red);
      return;
    }

    try {
      final List<UserInfo> userInfo = user.providerData;

      // Reauthenticate for Google users
      if (userInfo.any((info) => info.providerId == "google.com")) {
        final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
        if (gUser == null) {
          showToast("Google reauthentication failed.", Colors.red);
          return;
        }

        final GoogleSignInAuthentication gAuth = await gUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken,
          idToken: gAuth.idToken,
        );

        await user.reauthenticateWithCredential(credential);
      }
      // Reauthenticate for GitHub users
      else if (userInfo.any((info) => info.providerId == "github.com")) {
        final GithubAuthProvider githubAuthProvider = GithubAuthProvider();
        await user.reauthenticateWithProvider(githubAuthProvider);
      }
      // Reauthenticate for email/password users
      else if (userInfo.any((info) => info.providerId == "password")) {
        final String? password = await _passwordPrompt(context);
        if (password == null || password.isEmpty) {
          showToast("Please provide a password", Colors.red);
          return;
        }
        final AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
      } else {
        showToast("Unknown provider.", Colors.red);
        return;
      }

      print("===============================================");
      // Delete data from Firestore
      await FirestoreDataSource().deleteUser(user.uid);

      // Delete the account
      await user.delete();

      // Sign out
      await _auth.signOut();
      await GoogleSignIn().signOut();

      Navigator.of(context).pushNamedAndRemoveUntil(
        "/login",
        (Route<dynamic> route) => false, // Removes all routes in the stack
      );

      showToast("Account deleted successfully.", Colors.blue);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      print("Error deleting account: $e");
    }
  }

  /// Saves the authenticated user to Firestore, if applicable.
  _saveUserToFirestore(UserCredential userCredential) {
    final User? user = userCredential.user;
    if (user != null) {
      final String name = user.displayName ?? "Unknown User";
      final String email = user.email ?? "No Email";
      FirestoreDataSource().createUser(name, email);
    }
  }

  /// Handles Firebase authentication errors and displays appropriate messages.
  _handleAuthError(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case "weak-password":
        message = "The provided password is too weak!";
        break;
      case "email-already-in-use":
        message = "Email address already in use!";
        break;
      case "user-not-found":
        message = "No user found for this email!";
        break;
      case "wrong-password":
        message = "Invalid password!";
        break;
      default:
        message = "Authentication error ${e.message}";
    }
    showToast(message, Colors.red);
  }

  Future<String?> _passwordPrompt(BuildContext context) async {
    final TextEditingController passwordController = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Please enter your password"),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Enter your password",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, passwordController.text);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }
}
