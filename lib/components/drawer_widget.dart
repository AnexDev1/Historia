import 'package:flutter/material.dart';
import 'package:historia/screens/about_screen.dart';
import 'package:historia/screens/auth/login.dart';
import 'package:historia/screens/home_page.dart';
import 'package:historia/screens/settings.dart';

Widget buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        buildDrawerHeader(context),
        const SizedBox(height: 8.0), // Add space between header and items
        Column(
          children: [
            buildDrawerItem('Home', Icons.home, context),
            const SizedBox(height: 8.0), // Add space between items
            buildDrawerItem('About', Icons.question_mark_rounded, context),
            const SizedBox(height: 8.0), // Add space between items
            buildDrawerItem('Settings', Icons.settings, context),
          ],
        ),
      ],
    ),
  );
}

Widget buildDrawerHeader(BuildContext context) {
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
      child: DrawerHeader(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(
                'assets/people.jpg',
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              userName.isNotEmpty
                  ? userName
                  : 'User', // Replace with the name of the user
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : Colors.white,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildDrawerItem(String title, IconData icon, BuildContext context) {
  final currentThemeMode = Theme.of(context).brightness;

  Color getTextColor() {
    if (currentThemeMode == Brightness.dark) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  Color getIconColor() {
    if (currentThemeMode == Brightness.dark) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: currentThemeMode == Brightness.dark
                ? [
                    const Color.fromARGB(255, 138, 113, 247),
                    const Color.fromARGB(255, 181, 193, 223),
                  ]
                : [
                    const Color.fromARGB(255, 181, 193, 223),
                    const Color.fromARGB(255, 138, 113, 247),
                  ],
            begin: Alignment.bottomRight,
            end: Alignment.bottomLeft,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
          title: Row(
            children: [
              Icon(
                icon,
                color: getIconColor(),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: getTextColor(),
                  ),
                ),
              ),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward,
            color: getTextColor(),
          ),
          onTap: () {
            if (title == 'About') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              );
            } else if (title == 'Home') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
              // Add your navigation logic for other items here
            } else if (title == 'Settings') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingScreen(),
                ),
              );
            }
          },
        ),
      ),
    ),
  );
}
