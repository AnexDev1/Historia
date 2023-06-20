import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:provider/provider.dart';
import 'package:historia/theme_provider.dart';

class CityScreen extends StatefulWidget {
  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _cities = []; // Initialize with an empty list

  var currentThemeMode;
  var textColor;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchCities();
  }

  Future<void> _fetchCities() async {
    final snapshot = await _firestore.collection('cities').get();
    setState(() {
      _cities = snapshot.docs;
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
        child: _cities.isEmpty // Check if _cities is empty
            ? const Center(child: CircularProgressIndicator())
            : PageView.builder(
                itemCount: _cities.length,
                controller: PageController(initialPage: _currentPage),
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (BuildContext context, int index) {
                  final data = _cities[index].data() as Map<String, dynamic>;
                  final imageLink = data['imageLink'];

                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 300.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 30.0,
                                    left: 15.0,
                                    right: 30.0,
                                    bottom: 20.0,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(imageLink),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal: 30.0,
                                ),
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
                                padding: const EdgeInsets.only(
                                    left: 30.0, right: 30.0),
                                child: Text(
                                  data['description'],
                                  style: TextStyle(
                                    height: 1.5,
                                    fontSize: 18.0,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 20.0, bottom: 20.0),
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          backgroundColor: textColor,
                          onPressed: () {
                            _shareContent(data['title'], data['description']);
                          },
                          child: const Icon(Icons.share),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
