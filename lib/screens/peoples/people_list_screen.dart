import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:historia/screens/peoples/people_screen.dart';
import 'package:provider/provider.dart';
import 'package:historia/theme_provider.dart';

class PeopleListScreen extends StatefulWidget {
  const PeopleListScreen({Key? key}) : super(key: key);

  @override
  _PeopleListScreenState createState() => _PeopleListScreenState();
}

class _PeopleListScreenState extends State<PeopleListScreen> {
  late Stream<QuerySnapshot> _peopleStream;
  List<DocumentSnapshot> _people = [];
  List<DocumentSnapshot> _filteredPeople = [];
  TextEditingController _searchController = TextEditingController();
  var currentThemeMode;
  var textColor;

  @override
  void initState() {
    super.initState();
    _peopleStream =
        FirebaseFirestore.instance.collection('peoples').snapshots();
  }

  void _filterPeople(String personName) {
    setState(() {
      _filteredPeople = _people
          .where((doc) => (doc.data() as Map<String, dynamic>)['personName']
              .toString()
              .toLowerCase()
              .startsWith(personName.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    currentThemeMode = Provider.of<ThemeProvider>(context).currentThemeMode;
    textColor =
        currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            color: currentThemeMode == ThemeMode.dark
                ? Colors.black
                : Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.grey),
          ),
          child: TextFormField(
            controller: _searchController,
            onChanged: _filterPeople,
            decoration: InputDecoration(
              hintText: 'Search by Person Name',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
            ),
            style: TextStyle(color: Colors.black, fontSize: 18.0),
          ),
        ),
        toolbarHeight: 80.0,
        centerTitle: true,
        backgroundColor:
            Colors.transparent, // Set the background color to transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 181, 193, 223),
                Color.fromARGB(255, 138, 113, 247),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 15.0,
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _peopleStream,
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

                    _people = snapshot.data!.docs;

                    final people = _searchController.text.isEmpty
                        ? _people
                        : _filteredPeople;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: .8,
                        crossAxisSpacing: 15.0,
                        mainAxisSpacing: 15.0,
                      ),
                      itemCount: people.length,
                      itemBuilder: (BuildContext context, int index) {
                        final doc = people[index];
                        final data = doc.data() as Map<String, dynamic>?;

                        if (data == null) {
                          return SizedBox.shrink();
                        }

                        final imageLink = data['imageLink'] as String;
                        final documentId = doc.id;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PeopleScreen(
                                  documentId: documentId,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              image: DecorationImage(
                                image: NetworkImage(imageLink),
                                fit: BoxFit.cover,
                              ),
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
