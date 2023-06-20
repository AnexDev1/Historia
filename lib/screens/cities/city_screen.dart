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
  var currentThemeMode;
  var textColor;
  int currentPage = 0;

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
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('cities').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data!.docs;

            if (data.isEmpty) {
              return const Center(child: Text('No data found'));
            }

            return PageView.builder(
              itemCount: data.length,
              controller: PageController(initialPage: currentPage),
              onPageChanged: (int index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                final docData = data[index].data() as Map<String, dynamic>;
                final imageLink = docData['imageLink'];
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
                                      docData['title'], docData['description']);
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
                          docData['title'],
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
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: Text(
                          docData['description'],
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 18.0,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
