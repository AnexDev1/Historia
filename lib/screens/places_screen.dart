import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlacesScreen extends StatefulWidget {
  final String documentId; // New parameter

  const PlacesScreen({Key? key, required this.documentId}) : super(key: key);

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot>(
          future: _firestore
              .collection('places')
              .doc(widget.documentId) // Use the provided document ID
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('No data found'));
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final imageLink = data['imageLink'];

            return ListView(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 20.0, left: 15.0),
                  child: FloatingActionButton(
                    backgroundColor: Colors.black,
                    onPressed: () {
                      return Navigator.pop(context);
                    },
                    child: const Icon(Icons.close),
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
                      child: Image.network(imageLink), // Use NetworkImage
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
                      color: Colors.black87,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Text(
                    data['description'],
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 18.0,
                    ),
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
