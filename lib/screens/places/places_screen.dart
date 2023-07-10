import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:provider/provider.dart';
import 'package:historia/provider/theme_provider.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({Key? key}) : super(key: key);

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _places = [];
  int _currentPage = 0;
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
        child: _places.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      itemCount: _places.length,
                      controller: PageController(initialPage: _currentPage),
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      itemBuilder: (BuildContext context, int index) {
                        final data =
                            _places[index].data() as Map<String, dynamic>;
                        final imageLink = data['imageLink'];

                        return SingleChildScrollView(
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
                                padding: const EdgeInsets.only(
                                    left: 30.0, right: 30.0),
                                child: Text(
                                  data['description'],
                                  style: TextStyle(
                                      height: 1.5,
                                      fontSize: 18.0,
                                      color: textColor),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < _places.length; i++)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentPage = i;
                              });
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              width: 30.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    i == _currentPage ? textColor : Colors.grey,
                              ),
                              child: Center(
                                child: Text(
                                  '${i + 1}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 20.0, bottom: 20.0),
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton(
                      backgroundColor: textColor,
                      onPressed: () {
                        final data = _places[_currentPage].data()
                            as Map<String, dynamic>;
                        _shareContent(data['title'], data['description']);
                      },
                      child: const Icon(Icons.share),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
