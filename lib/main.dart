import 'package:flutter/material.dart';
import 'screens/start_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/home_screen.dart';
import 'screens/main_screen.dart';
import 'screens/edit_profile_screen.dart';

void main() => runApp(const CoffeeFinderApp());

class CoffeeFinderApp extends StatelessWidget {
  const CoffeeFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const StartScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const MainScreen(),
        "/edit-profile": (context) => const EditProfileScreen(),
      },
    );
  }
}
