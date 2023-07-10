import 'package:flutter/material.dart';
import 'package:historia/screens/about_screen.dart';
import 'package:historia/screens/home_page.dart';
import 'package:historia/screens/settings.dart';

class AppDrawer extends StatelessWidget {
  final String userName; // Pass the user name as a parameter
  final BuildContext context; // Add context as a parameter

  const AppDrawer({Key? key, required this.userName, required this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentThemeMode = Theme.of(context).brightness;

    Color getTextColor() {
      return currentThemeMode == Brightness.dark ? Colors.black : Colors.white;
    }

    Color getIconColor() {
      return currentThemeMode == Brightness.dark ? Colors.black : Colors.white;
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
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
                    userName.isNotEmpty ? userName : 'User',
                    style: TextStyle(
                      color: getTextColor(),
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          buildDrawerItem(
              'Home', Icons.home, context, getTextColor, getIconColor),
          const SizedBox(height: 8.0),
          buildDrawerItem('About', Icons.question_mark_rounded, context,
              getTextColor, getIconColor),
          const SizedBox(height: 8.0),
          buildDrawerItem(
              'Settings', Icons.settings, context, getTextColor, getIconColor),
        ],
      ),
    );
  }

  Widget buildDrawerItem(String title, IconData icon, BuildContext context,
      Color Function() getTextColor, Color Function() getIconColor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: getGradientColors(),
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
          onTap: () => handleDrawerItemClick(title, context),
        ),
      ),
    );
  }

  void handleDrawerItemClick(String title, BuildContext context) {
    switch (title) {
      case 'Home':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
        break;
      case 'About':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AboutScreen(),
          ),
        );
        break;
      case 'Settings':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingScreen(),
          ),
        );
        break;
    }
  }

  List<Color> getGradientColors() {
    final currentThemeMode = Theme.of(context).brightness;
    return currentThemeMode == Brightness.dark
        ? [
            const Color.fromARGB(255, 138, 113, 247),
            const Color.fromARGB(255, 181, 193, 223),
          ]
        : [
            const Color.fromARGB(255, 181, 193, 223),
            const Color.fromARGB(255, 138, 113, 247),
          ];
  }
}

// Usage example:
