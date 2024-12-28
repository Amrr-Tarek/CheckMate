import 'package:checkmate/controllers/calendar_provider.dart';
import 'package:checkmate/controllers/user_provider.dart';
import 'package:checkmate/pages/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:checkmate/pages/sign_up.dart';
import 'package:checkmate/pages/loading_screen.dart';
import 'package:checkmate/pages/log_in.dart';
import 'package:checkmate/pages/home.dart';
import 'package:checkmate/pages/calendar.dart';
import 'package:checkmate/pages/routine.dart';
import 'package:checkmate/pages/goals.dart';
import 'package:checkmate/pages/my_profile.dart';
import 'package:checkmate/pages/settings.dart';
import 'package:checkmate/firebase_options.dart';
import 'package:provider/provider.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var message = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print(message);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        // need to add the id
        // ChangeNotifierProvider(create: (context) => CalendarProvider(eventName: "no events today", eventDate: DateTime.now())),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, mode, __) {
          return MaterialApp(
            // initialRoute: '/',
            debugShowCheckedModeBanner: false,
            home: const LoadingScreen(),
            routes: {
              '/loading': (context) => const LoadingScreen(),
              '/signup': (context) => const SignUpPage(),
              '/login': (context) => const LoginScreen(),
              '/reset': (context) => const ResetPassword(),
              '/home': (context) => const HomePage(),
              '/calendar': (context) => const Calendar(),
              '/routine': (context) => const RoutinePage(),
              '/goals': (context) => const Goals(),
              '/myprofile': (context) => const MyProfile(),
              '/settings': (context) => const Settings(),
            },
            theme: ThemeData(
              fontFamily: "Cairo",
              brightness: Brightness.light,
              primaryColor: const Color(0xFF6750a4),
              shadowColor: const Color(0xFF000000),
              cardColor: const Color(0xFFFFFFFF),
              secondaryHeaderColor: const Color(0xFFB9A3F4),
            ),
            darkTheme: ThemeData(
              fontFamily: "Cairo",
              brightness: Brightness.dark,
              primaryColor: const Color(0xFF6750a4),
              shadowColor: const Color(0xFFFFFFFF),
              cardColor: const Color.fromARGB(255, 60, 4, 142),
              secondaryHeaderColor: const Color.fromARGB(255, 88, 55, 178),
            ),
            themeMode: mode,
          );
        },
      ),
    );
  }
}
