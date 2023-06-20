import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:historia/screens/peoples/people_screen.dart';

class BuildPlacesList extends StatelessWidget {
  const BuildPlacesList({super.key});

  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;

    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('peoples').limit(1).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              final documentId = doc.id;
              final data = doc.data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PeopleScreen(),
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
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(data['imageLink']),
                                    fit: BoxFit.cover),
                                borderRadius: const BorderRadius.all(
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
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              blurRadius: 3,
                                              offset: const Offset(2, 2),
                                            ),
                                          ],
                                        ),
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
    );
  }
}
