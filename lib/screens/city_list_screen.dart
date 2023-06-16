import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:historia/screens/city_screen.dart';

class CitiesListScreen extends StatefulWidget {
  const CitiesListScreen({Key? key}) : super(key: key);

  @override
  _CitiesListScreenState createState() => _CitiesListScreenState();
}

class _CitiesListScreenState extends State<CitiesListScreen> {
  late Stream<QuerySnapshot> _citiesStream;
  List<DocumentSnapshot> _cities = [];
  List<DocumentSnapshot> _filteredCities = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _citiesStream = FirebaseFirestore.instance.collection('cities').snapshots();
  }

  void _filterCities(String cityName) {
    setState(() {
      _filteredCities = _cities
          .where((doc) => (doc.data() as Map<String, dynamic>)['cityName']
              .toString()
              .toLowerCase()
              .startsWith(cityName.toLowerCase()))
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
            onChanged: _filterCities,
            decoration: InputDecoration(
              hintText: 'Search by City Name',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
            ),
            style: TextStyle(color: Colors.black, fontSize: 18.0),
          ),
        ),
        toolbarHeight: 80.0,
        centerTitle: true,
        backgroundColor: Colors.grey[600],
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
                  stream: _citiesStream,
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

                    _cities = snapshot.data!.docs;

                    final cities = _searchController.text.isEmpty
                        ? _cities
                        : _filteredCities;

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
                      itemCount: cities.length,
                      itemBuilder: (BuildContext context, int index) {
                        final doc = cities[index];
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
                                builder: (context) => CityScreen(
                                  documentId: documentId,
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: imageLink,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                image: DecorationImage(
                                  image: NetworkImage(imageLink),
                                  fit: BoxFit.cover,
                                ),
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
