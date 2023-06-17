import 'package:flutter/material.dart';
import 'package:historia/screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:historia/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    Widget initialScreen = user == null ? LoginPage() : const HomePage();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: initialScreen,
    );
  }
}
