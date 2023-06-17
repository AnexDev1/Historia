import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:historia/screens/places_screen.dart';

class PlacesListScreen extends StatefulWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  _PlacesListScreenState createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends State<PlacesListScreen> {
  late Stream<QuerySnapshot> _placesStream;
  List<DocumentSnapshot> _places = [];
  List<DocumentSnapshot> _filteredPlaces = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _placesStream = FirebaseFirestore.instance.collection('places').snapshots();
  }

  void _filterPlaces(String countryTag) {
    setState(() {
      _filteredPlaces = _places
          .where((doc) => (doc.data() as Map<String, dynamic>)['countryTag']
              .toString()
              .toLowerCase()
              .startsWith(countryTag.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.grey),
          ),
          child: TextFormField(
            controller: _searchController,
            onChanged: _filterPlaces,
            decoration: const InputDecoration(
              hintText: 'Search by Country',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
            ),
            style: const TextStyle(color: Colors.black, fontSize: 18.0),
          ),
        ),
        toolbarHeight: 80.0,
        centerTitle: true,
        backgroundColor: Colors.green[300],
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
                  stream: _placesStream,
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

                    _places = snapshot.data!.docs;

                    final places = _searchController.text.isEmpty
                        ? _places
                        : _filteredPlaces;

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
                      itemCount: places.length,
                      itemBuilder: (BuildContext context, int index) {
                        final doc = places[index];
                        final data = doc.data() as Map<String, dynamic>?;

                        if (data == null) {
                          return const SizedBox.shrink();
                        }

                        final imageLink = data['imageLink'] as String;
                        final documentId = doc.id;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlacesScreen(
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
