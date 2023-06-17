import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class PlacesScreen extends StatefulWidget {
  final String documentId;

  const PlacesScreen({Key? key, required this.documentId}) : super(key: key);

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final _firestore = FirebaseFirestore.instance;

  void _shareContent(String title, String description) {
    final text = '$title\n\n$description';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot>(
          future: _firestore.collection('places').doc(widget.documentId).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('No data found'));
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final imageLink = data['imageLink'];

            return ListView(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 20.0, left: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton(
                        backgroundColor: Colors.black,
                        onPressed: () {
                          return Navigator.pop(context);
                        },
                        child: const Icon(Icons.close),
                      ),
                      const SizedBox(width: 10.0),
                      FloatingActionButton(
                        backgroundColor: Colors.black,
                        onPressed: () {
                          _shareContent(data['title'], data['description']);
                        },
                        child: const Icon(Icons.share),
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
                      tag: imageLink,
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
                    style: const TextStyle(
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
                    style: const TextStyle(
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
