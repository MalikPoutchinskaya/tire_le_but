import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirelebut/models/player.dart';
import 'package:tirelebut/screens/createMatch/arena-create.dart';
import 'package:tirelebut/screens/home/player_list.dart';
import 'package:tirelebut/services/database-player.dart';

class PlayersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Player>>.value(
      value: DatabaseServicePlayer().players,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('All players'),
          backgroundColor: Colors.amberAccent[200],
          elevation: 0.0,
        ),
        body: Container(
          child: PlayerList(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ArenaCreateScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
