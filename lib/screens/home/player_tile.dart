import 'package:flutter/material.dart';
import 'package:tirelebut/models/player.dart';

class PlayerTile extends StatelessWidget {
  final Player player;

  PlayerTile({this.player});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(0, 6.0, 0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.yellow[player.matchPlayed],
            backgroundImage: NetworkImage(player.pictureUrl),
          ),
          title: Text(player.name),
          subtitle: Text(player.style),
        ),
      ),
    );
  }
}
