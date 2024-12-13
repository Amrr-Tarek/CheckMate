import 'package:flutter/material.dart';

void navigate(BuildContext context, String next) {
  final String? currentRouteName = ModalRoute.of(context)?.settings.name;

  if (currentRouteName == next) {
    Navigator.pop(context); // Pops the drawer
    return;
  }

  // Push
  // Replace with a check for a root widget when you remove login from the stack
  if ((currentRouteName == '/home') ||
      (isSub(currentRouteName) && isOp(next))) {
    // Navigate Normally
    Navigator.pushNamed(context, next);
  }

  // Push Replacement
  else if (isSub(currentRouteName) && isSub(next)) {
    // Replace the current page with its neighbor
    Navigator.pushReplacementNamed(context, next);
  }

  // Edge-Cases
  else if (isSub(currentRouteName) && next == '/home') {
    // Goes to the home page and refreshes it

    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/home');
  }
  // Default case
  else {
    Navigator.pushNamed(context, next);
  }
}

bool isSub(String? page) {
  if ({"/calendar", "/goals", "/routine"}.contains(page)) return true;
  return false;
}

bool isOp(String? page) {
  if ({"/myprofile", "/settings"}.contains(page)) return true;
  return false;
}
