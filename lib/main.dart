import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'package:flutter/material.dart';
import 'signup.dart'; // Import the signup.dart file

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures proper binding
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp()); // Run your app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Group8Widget(), // Start with the Group8Widget
    );
  }
}

class Group8Widget extends StatelessWidget {
  const Group8Widget({super.key});

  @override
  Widget build(BuildContext context) {
    // Wait for 2 seconds and then navigate to the sign-up page
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CreateAccountPage()), // Navigate to the CreateAccountPage
      );
    });

    return Scaffold(
      body: Center(
        child: Container(
          width: 800,
          height: 843,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(29),
            image: const DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
