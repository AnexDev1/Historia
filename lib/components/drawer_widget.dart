import 'package:flutter/material.dart';

Widget buildDrawer() {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        buildDrawerHeader(),
        const SizedBox(height: 8.0), // Add space between header and items
        Column(
          children: [
            buildDrawerItem('Home', Icons.home),
            const SizedBox(height: 8.0), // Add space between items
            buildDrawerItem('About', Icons.question_mark_rounded),
            const SizedBox(height: 8.0), // Add space between items
            buildDrawerItem('Settings', Icons.settings),
          ],
        ),
      ],
    ),
  );
}

Widget buildDrawerHeader() {
  return Container(
    color: const Color(0xff757575),
    child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFA8C0FF),
            Color(0xFF3F2B96),
          ],
          begin: Alignment.bottomRight,
          end: Alignment.bottomLeft,
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
        ),
      ),
      child: const DrawerHeader(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                'https://randomuser.me/api/portraits/women/8.jpg', // Replace with the URL of the profile picture
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'John Doe', // Replace with the name of the user
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildDrawerItem(String title, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 181, 193, 223),
              Color.fromARGB(255, 138, 113, 247),
            ],
            begin: Alignment.bottomRight,
            end: Alignment.bottomLeft,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 24.0), // Add padding to the left and right
          title: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          trailing: const Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
          onTap: () {
            // Add your navigation logic here
          },
        ),
      ),
    ),
  );
}
