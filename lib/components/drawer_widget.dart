import 'package:flutter/material.dart';

Widget buildDrawer() {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        buildDrawerHeader(),
        buildDrawerItem('Item 1'),
        buildDrawerItem('Item 2'),
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
        child: Text(
          'Drawer Header',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    ),
  );
}

Widget buildDrawerItem(String title) {
  return ClipRRect(
    borderRadius: const BorderRadius.only(
      bottomRight: Radius.circular(20.0),
    ),
    child: ListTile(
      title: Text(title),
      onTap: () {
        // Add your navigation logic here
      },
    ),
  );
}
