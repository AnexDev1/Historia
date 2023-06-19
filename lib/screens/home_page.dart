import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:historia/components/drawer_widget.dart';
import 'package:historia/components/list_box.dart';
import 'package:historia/screens/cities/city_list_screen.dart';
import 'package:historia/screens/auth/login.dart';
import 'package:historia/screens/peoples/people_list_screen.dart';
import 'package:historia/screens/places/places_list_screen.dart';
import 'package:historia/screens/places/places_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:historia/theme_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firestore = FirebaseFirestore.instance;
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
              buildPlacesList(),
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
        MaterialPageRoute(builder: (context) => LoginPage()),
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
      padding: EdgeInsets.symmetric(vertical: 30.0),
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
            imagePath: 'assets/palce.jpg',
            text: 'Places',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlacesListScreen(),
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
                  builder: (context) => const PeopleListScreen(),
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
                  builder: (context) => const CitiesListScreen(),
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

  Widget buildPlacesList() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('places').limit(1).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final doc = documents[index];
              final data = doc.data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacesScreen(
                        documentId: doc.id,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.9,
                          child: Material(
                            elevation: 4.0,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            child: Container(
                              height: 55.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(data['imageLink']),
                                    fit: BoxFit.cover),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      data['title'],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              blurRadius: 3,
                                              offset: Offset(2, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
