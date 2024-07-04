import 'package:flutter/material.dart';
import 'package:historia/components/drawer_widget.dart';
import 'package:historia/components/list_box.dart';
import 'package:historia/screens/auth/login.dart';
import 'package:historia/screens/places/places_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:historia/provider/theme_provider.dart';
import 'package:provider/provider.dart';

import 'peoples/people_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ThemeMode currentThemeMode;
  late Color textColor;

  @override
  void initState() {
    super.initState();
    currentThemeMode =
        Provider.of<ThemeProvider>(context, listen: false).currentThemeMode;
    textColor =
        currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black;
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
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Text(
        'Know your Heritage',
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            fontSize: 50.0,
            fontWeight: FontWeight.w900,
            color: textColor,
            letterSpacing: .5,
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> categories = [
    {'imagePath': 'assets/place.jpg', 'text': 'Places', 'screen': const PlacesScreen()},
    {'imagePath': 'assets/people.jpg', 'text': 'People', 'screen': PeopleScreen()},
    {'imagePath': 'assets/animal.jpg', 'text': 'Animals', 'screen': PeopleScreen()},
    {'imagePath': 'assets/food.jpg', 'text': 'Foods', 'screen': PeopleScreen()},
    {'imagePath': 'assets/culture.jpg', 'text': 'Cultures', 'screen': PeopleScreen()},
  ];

  Widget buildListBoxes() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2 / 3,
      crossAxisSpacing: 15.0,
      mainAxisSpacing: 10.0,
      children: categories.map((category) {
        return ListBox(
          imagePath: category['imagePath'],
          text: category['text'],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => category['screen']),
            );
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(
        context: context,
        userName: userName,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            pinned: true,
            leading: IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: Icon(
                Icons.menu,
                size: 30.0,
                color: textColor,
              ),
            ),
            actions: [
              IconButton(
                onPressed: _logout,
                icon: Icon(
                  Icons.logout,
                  size: 30.0,
                  color: textColor,
                ),
              ),
            ],
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
              child: Column(
                children: [
                  buildTitle(),
                  buildListBoxes(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
