import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tirelebut/models/player.dart';
import 'package:tirelebut/screens/createMatch/match-create.dart';
import 'package:tirelebut/screens/home/profile-screen.dart';
import 'package:tirelebut/services/database-player.dart';

import 'fab_bottom_bar.dart';
import 'matches_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = [
    MatchesScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Create a match'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return MatchCreateScreen();
            }),
          );
        },
        icon: Icon(Icons.add),
        elevation: 2.0,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: FABBottomAppBar(
        onTabSelected: _onItemTapped,
        selectedColor: Colors.teal,
        color: Colors.blueGrey,
        items: [
          FABBottomAppBarItem(iconData: Icons.videogame_asset, text: 'Matches'),
          FABBottomAppBarItem(iconData: Icons.person, text: 'Profile'),
        ],
      ),
    );
  }
}
