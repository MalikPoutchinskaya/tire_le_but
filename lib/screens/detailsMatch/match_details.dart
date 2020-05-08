import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:tirelebut/models/match.dart';
import 'package:tirelebut/models/player.dart';
import 'package:tirelebut/models/user.dart';
import 'package:tirelebut/screens/home/player_list.dart';
import 'package:tirelebut/services/database-match.dart';
import 'package:tirelebut/services/database-player.dart';

class MatchDetailsState extends StatefulWidget {
  final Match match;

  MatchDetailsState({Key key, @required this.match}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MatchDetailsState();
  }
}

class _MatchDetailsState extends State<MatchDetailsState> {
  @override
  MatchDetailsState get widget => super.widget;
  DateFormat dateFormatDay = DateFormat("dd");
  DateFormat dateFormatMonth = DateFormat.MMM();

  String _getMatchDay(int dateSinceEpoch) {
    var date = new DateTime.fromMillisecondsSinceEpoch(dateSinceEpoch);
    var dateFormatted = dateFormatDay.format(date);
    return dateFormatted;
  }

  String _getMatchMonth(int dateSinceEpoch) {
    var date = new DateTime.fromMillisecondsSinceEpoch(dateSinceEpoch);
    var dateFormatted = dateFormatMonth.format(date);
    return dateFormatted;
  }

  @override
  Widget build(BuildContext context) {
    var match = widget.match;
    User user = Provider.of<User>(context);
    return StreamBuilder<Player>(
        stream: DatabaseServicePlayer().getPlayer(user.uid),
        builder: (context, snapshot) {
          Player player = snapshot.data;
          return Scaffold(
            backgroundColor: Colors.deepOrangeAccent[100],
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(color: Colors.white),
              elevation: 0,
              title: const Text('Match details',
                  style: TextStyle(color: Colors.white)),
            ),
            body: Container(
                child: Builder(
                    builder: (context) => ListView(
                        shrinkWrap: true,
                        padding:
                        const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 0.0),
                        children: [
                          Text(
                            match.name,
                            style: Theme.of(context)
                                .textTheme
                                .display3
                                .apply(color: Colors.white),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "${match.arena.name}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline
                                              .apply(
                                              color: Colors.teal,
                                              fontWeightDelta: 2),
                                        ),
                                        Spacer(),
                                        IconButton(
                                          icon: Icon(
                                            Icons.map,
                                            color: Colors.teal,
                                          ),
                                          onPressed: () {
                                            MapsLauncher.launchQuery(
                                                match.arena.location);
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: match.arena.location,
                                            style: Theme.of(context)
                                                .textTheme
                                                .body2
                                                .apply(color: Colors.teal),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(25.0),
                                    color: Colors.teal,
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            match.time,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline
                                                .apply(color: Colors.white),
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          _getMatchDay(match.date),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline
                                              .apply(color: Colors.white),
                                        ),
                                        Text(
                                          _getMatchMonth(match.date),
                                          style: Theme.of(context)
                                              .textTheme
                                              .body1
                                              .apply(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            "Players",
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .apply(color: Colors.white),
                          ),
                          PlayerList(match: match),
                          SizedBox(
                            height: 70.0,
                          ),
                        ]))),
            floatingActionButton: Visibility(
              visible: !match.playerIds.contains(user.uid),
              child: FloatingActionButton.extended(
                backgroundColor:
                match.isMatchComplete() ? Colors.grey : Colors.teal,
                onPressed: () async {
                  match.isMatchComplete()
                      ? null
                      : await DatabaseServiceMatch()
                      .updateMatchPlayerIds(match, user.uid);
                  player.matchIds.add(match.id);
                  await DatabaseServicePlayer().updateUserDataWithPlayer(player);
                  Navigator.pop(context);
                },
                icon: Icon(match.isMatchComplete() ? Icons.warning : Icons.check),
                label: Text(match.isMatchComplete()
                    ? "This match is full!"
                    : "Participated!"),
              ),
            ),
          );
        });
  }
}
