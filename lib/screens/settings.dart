import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:historia/theme_provider.dart';

enum ThemeModeOption {
  light,
  dark,
}

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  ThemeModeOption? _selectedOption = ThemeModeOption.light;

  void _onOptionChanged(ThemeModeOption? option) {
    setState(() {
      _selectedOption = option;
    });

    // Set the theme mode based on the selected option
    if (_selectedOption == ThemeModeOption.light) {
      Provider.of<ThemeProvider>(context, listen: false)
          .setThemeMode(ThemeMode.light);
    } else if (_selectedOption == ThemeModeOption.dark) {
      Provider.of<ThemeProvider>(context, listen: false)
          .setThemeMode(ThemeMode.dark);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<ThemeModeOption>(
                      value: _selectedOption,
                      onChanged: _onOptionChanged,
                      isExpanded: true,
                      items: [
                        DropdownMenuItem(
                          value: ThemeModeOption.light,
                          child: Text('Light'),
                        ),
                        DropdownMenuItem(
                          value: ThemeModeOption.dark,
                          child: Text('Dark'),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
