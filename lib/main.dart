import 'package:checkmate/pages/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/pages/loading_screen.dart';
import 'package:checkmate/pages/log_in.dart';
import 'package:checkmate/pages/home.dart';
import 'package:checkmate/pages/calendar.dart';
import 'package:checkmate/pages/routine.dart';
import 'package:checkmate/pages/goals.dart';
import 'package:checkmate/pages/my_profile.dart';
import 'package:checkmate/pages/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: '/home',
      debugShowCheckedModeBanner: false,
      home: const LoadingScreen(),
      routes: {
        '/loading': (context) => const LoadingScreen(),
        '/SignUpPage': (context) => const SignUpPage(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomePage(),
        '/calendar': (context) => const Calendar(),
        '/routine': (context) => const RoutinePage(),
        '/goals': (context) => const Goals(),
        '/myprofile': (context) => const MyProfile(),
        '/settings': (context) => const Settings(),
      },
      theme: ThemeData(fontFamily: "Cairo"),
    );
  }
}
