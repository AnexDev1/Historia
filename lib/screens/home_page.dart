import 'package:flutter/material.dart';
import 'package:historia/components/drawer_widget.dart';
import 'package:historia/components/list_box.dart';
import 'package:historia/components/recent_lists.dart';
import 'package:historia/screens/auth/login.dart';
import 'package:historia/screens/cities/city_screen.dart';
import 'package:historia/screens/places/places_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:historia/theme_provider.dart';
import 'package:provider/provider.dart';

import 'peoples/people_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final _firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var currentThemeMode;
  var textColor;
  @override
  Widget build(BuildContext context) {
    currentThemeMode = Provider.of<ThemeProvider>(context).currentThemeMode;
    textColor =
        currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black;
    return Scaffold(
      key: _scaffoldKey,
      drawer: buildDrawer(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
          child: Column(
            children: [
              buildTopRow(),
              buildTitle(),
              buildListBoxes(),
              buildRecentlyAdded(),
              BuildPlacesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(
            Icons.menu,
            size: 30.0,
            color: textColor,
          ),
        ),
        IconButton(
          onPressed: () {
            _logout();
          },
          icon: Icon(
            Icons.logout,
            size: 30.0,
            color: textColor,
          ),
        ),
      ],
    );
  }

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Logout Failed'),
            content: const Text(
              'An error occurred while logging out. Please try again.',
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Widget buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Text(
        'Know your Heritage',
        style: GoogleFonts.montserrat(
            textStyle: TextStyle(
          fontSize: 45.0,
          fontWeight: FontWeight.w900,
          color: textColor,
          letterSpacing: .5,
        )),
      ),
    );
  }

  Widget buildListBoxes() {
    return SizedBox(
      height: 220.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ListBox(
            imagePath: 'assets/place.jpg',
            text: 'Places',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlacesScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 10.0),
          ListBox(
            imagePath: 'assets/people.jpg',
            text: 'People',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PeopleScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 10.0),
          ListBox(
            imagePath: 'assets/city.jpg',
            text: 'Cities',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CityScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildRecentlyAdded() {
    return Container(
      padding: const EdgeInsets.only(top: 40.0, bottom: 10.0),
      alignment: Alignment.centerLeft,
      child: Text(
        'Recently Added',
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              letterSpacing: .6,
              color: textColor),
        ),
      ),
    );
  }
}
