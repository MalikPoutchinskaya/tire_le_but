import 'package:flutter/material.dart';
import 'package:tirelebut/models/match.dart';
import 'package:tirelebut/models/player.dart';
import 'package:tirelebut/screens/home/player_tile.dart';
import 'package:tirelebut/services/database-player.dart';
import 'package:tirelebut/shared/loading_accent.dart';

class PlayerList extends StatefulWidget {
  final Match match;

  PlayerList({Key key, @required this.match}) : super(key: key);

  @override
  _PlayerListState createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  @override
  PlayerList get widget => super.widget;

  @override
  Widget build(BuildContext context) {
    var match = widget.match;
//    final players = Provider.of<List<Player>>(context) ?? [];

    return StreamBuilder<List<Player>>(
        stream: DatabaseServicePlayer().getPlayersById(match.playerIds),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Player> players = snapshot.data;
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: players.length,
              itemBuilder: (context, index) {
                return PlayerTile(player: players[index]);
              },
            );
          } else {
            return LoadingAccent();
          }
        });
  }
}
