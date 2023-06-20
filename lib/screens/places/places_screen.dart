import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:provider/provider.dart';
import 'package:historia/theme_provider.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({Key? key}) : super(key: key);

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _places = []; // Initialize with an empty list
  int _currentPage = 0; // Initialize with 0
  var currentThemeMode;
  var textColor;

  @override
  void initState() {
    super.initState();
    _fetchPlaces();
  }

  Future<void> _fetchPlaces() async {
    final snapshot = await _firestore.collection('places').get();
    setState(() {
      _places = snapshot.docs;
    });
  }

  void _shareContent(String title, String description) {
    final text = '$title\n\n$description';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    currentThemeMode = Provider.of<ThemeProvider>(context).currentThemeMode;
    textColor =
        currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black;
    return Scaffold(
      body: SafeArea(
        child: _places.isEmpty // Check if _places is empty
            ? const Center(child: CircularProgressIndicator())
            : PageView.builder(
                itemCount: _places.length,
                controller: PageController(initialPage: _currentPage),
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (BuildContext context, int index) {
                  final data = _places[index].data() as Map<String, dynamic>;
                  final imageLink = data['imageLink'];

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 20.0, left: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 56,
                                height: 56,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  borderRadius: BorderRadius.circular(28),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      color: textColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: currentThemeMode == ThemeMode.dark
                                          ? Colors.black
                                          : Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: FloatingActionButton(
                                  backgroundColor: textColor,
                                  onPressed: () {
                                    _shareContent(
                                        data['title'], data['description']);
                                  },
                                  child: const Icon(Icons.share),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 300.0,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 30.0,
                              left: 15.0,
                              right: 30.0,
                              bottom: 20.0,
                            ),
                            child: Hero(
                              tag: 'heroTag',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(imageLink),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 30.0),
                          child: Text(
                            data['title'],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              height: .9,
                              letterSpacing: .2,
                              fontSize: 40.0,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Text(
                            data['description'],
                            style: TextStyle(
                                height: 1.5, fontSize: 18.0, color: textColor),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
