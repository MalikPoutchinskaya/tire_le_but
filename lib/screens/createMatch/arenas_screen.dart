import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirelebut/models/arena.dart';
import 'package:tirelebut/screens/createMatch/arena_list.dart';
import 'package:tirelebut/services/database-arena.dart';

import 'arena-create.dart';

class ArenasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Arena>>.value(
      value: DatabaseServiceArena().arenas,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Select your arena'),
            backgroundColor: Colors.teal,
            elevation: 0.0,
          ),
          body: Container(
              child: ArenaList()),
          floatingActionButton: FloatingActionButton.extended(
              icon: Icon(Icons.add),
              label: Text("Create arena"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ArenaCreateScreen()),
                );
              },
            ),
          ),
    );
  }
}
