import 'package:flutter/material.dart';
import 'package:geldstroom/screens/home_screen.dart';
import 'package:geldstroom/screens/records_screen.dart';
import 'package:geldstroom/screens/settings_screen.dart';

class TabsScreen extends StatefulWidget {
  static final routeName = '/tabsscreen';

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;

  final pages = [
    HomeScreen(),
    RecordsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
              title: Text('Home'),
              icon: Icon(Icons.home),
              backgroundColor: Theme.of(context).accentColor),
          BottomNavigationBarItem(
            title: Text('Records'),
            icon: Icon(Icons.library_books),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            title: Text('Settings'),
            icon: Icon(Icons.settings),
            backgroundColor: Colors.deepOrange,
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
    );
  }
}
