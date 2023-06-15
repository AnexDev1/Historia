import 'package:flutter/material.dart';
import 'package:historia/components/list_box.dart';
import 'package:historia/screens/city_list_screen.dart';
import 'package:historia/screens/people_list_screen.dart';
import 'package:historia/screens/places_list_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Colors.brown[200],
                      child: const Text(
                        'An',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30.0),
                child: Text(
                  'Know your Heritage',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .5,
                  ),
                ),
              ),
              SizedBox(
                height: 220.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ListBox(
                      color: Colors.green[300],
                      text: 'ቦታዎች',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PlacesListScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    ListBox(
                      color: Colors.orange[300],
                      text: 'ሰዎች',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PeoplesListScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    ListBox(
                      color: Colors.grey[600],
                      text: 'ከተሞች',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CitiesListScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20.0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Recently Viewed',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
