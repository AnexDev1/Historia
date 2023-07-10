import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:historia/screens/home_page.dart';
import 'package:historia/screens/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    Widget initialScreen = user == null ? LoginPage() : const HomePage();
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: ThemeData(
            textTheme: GoogleFonts.latoTextTheme(),
            brightness: themeProvider.currentThemeMode == ThemeMode.dark
                ? Brightness.dark
                : Brightness.light,
          ),
          darkTheme: ThemeData.dark().copyWith(
            textTheme: GoogleFonts.latoTextTheme(),
          ),
          themeMode: themeProvider.currentThemeMode,
          debugShowCheckedModeBanner: false,
          home: initialScreen,
        );
      },
    );
  }
}
