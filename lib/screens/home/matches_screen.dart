import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirelebut/models/match.dart';
import 'package:tirelebut/models/player.dart';
import 'package:tirelebut/models/user.dart';
import 'package:tirelebut/screens/home/match_list.dart';
import 'package:tirelebut/services/database-match.dart';
import 'package:tirelebut/services/database-player.dart';
import 'package:tirelebut/shared/loading.dart';

class MatchesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MatchesScreen();
  }
}

class _MatchesScreen extends State<MatchesScreen> {
  @override
  Widget build(BuildContext context) {
    /**
     *
     */
    User user = Provider.of<User>(context);
    return StreamBuilder<Player>(
        stream: DatabaseServicePlayer(uid: user.uid).user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Player player = snapshot.data;
            return DefaultTabController(
                length: 2,
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    title: Text('Tire le but'),
                    backgroundColor: Colors.teal,
                    elevation: 0.0,
                    bottom: TabBar(
                      labelStyle: TextStyle(fontSize: 16.0),
                      tabs: [
                        Tab(
                          text: 'Feed',
                        ),
                        Tab(text: 'Matches coming'),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      StreamProvider<List<Match>>.value(
                          value: DatabaseServiceMatch().matches,
                          child: Container(child: MatchList())),
                      StreamProvider<List<Match>>.value(
                          value: DatabaseServiceMatch()
                              .getMyMatches(player.matchIds),
                          child: Container(child: MatchList())),
                    ],
                  ),
                ));
          } else {
            return Loading();
          }
        });
  }
}
