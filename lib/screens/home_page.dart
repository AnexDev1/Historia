import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:historia/components/list_box.dart';
import 'package:historia/screens/city_list_screen.dart';
import 'package:historia/screens/people_list_screen.dart';
import 'package:historia/screens/places_list_screen.dart';
import 'package:historia/screens/places_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              color: const Color(0xff757575),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFA8C0FF),
                      Color(0xFF3F2B96),
                    ],
                    begin: Alignment.bottomRight,
                    end: Alignment.bottomLeft,
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: const DrawerHeader(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Drawer Header',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20.0),
              ),
              child: ListTile(
                title: const Text('Item 1'),
                onTap: () {
                  // Add your navigation logic here
                },
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20.0),
              ),
              child: ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  // Add your navigation logic here
                },
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    icon: const Icon(
                      Icons.menu,
                      size: 30.0,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      color: Colors.grey[400],
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'An',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Know your Heritage',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .5,
                  ),
                ),
              ),
              SizedBox(
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
                    const SizedBox(
                      width: 10.0,
                    ),
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
                    const SizedBox(
                      width: 10.0,
                    ),
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
              ),
              Container(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Recently Added',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('places').limit(2).snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFFA8C0FF),
                                              Color(0xFF3F2B96),
                                            ],
                                            begin: Alignment.bottomRight,
                                            end: Alignment.bottomLeft,
                                            stops: [0.0, 1.0],
                                            tileMode: TileMode.clamp,
                                          ),
                                          borderRadius: BorderRadius.all(
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
                                                style: const TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
