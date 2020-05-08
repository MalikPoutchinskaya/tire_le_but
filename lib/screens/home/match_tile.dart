import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:tirelebut/models/match.dart';
import 'package:tirelebut/screens/detailsMatch/match_details.dart';

class MatchTile extends StatefulWidget {
  final Match match;

  MatchTile({this.match});

  @override
  State<StatefulWidget> createState() {
    return _MatchTile();
  }
}

class _MatchTile extends State<MatchTile> {
  @override
  MatchTile get widget => super.widget;

  DateFormat dateFormat = DateFormat("EEEE dd MMMM");

  DateFormat dateFormatDay = DateFormat("dd");
  DateFormat dateFormatMonth = DateFormat.MMM();

  String _getReadableDate(int dateSinceEpoch) {
    var date = new DateTime.fromMillisecondsSinceEpoch(dateSinceEpoch);
    var dateFormatted = dateFormat.format(date);
    return "$dateFormatted";
  }

  @override
  Widget build(BuildContext context) {
    var match = widget.match;

    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MatchDetailsState(match: match),
              ),
            );
          },
          child: Stack(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child:
                        Image.asset('assets/images/background_match_img.jpg'),
                  )),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  margin: const EdgeInsets.only(top: 200),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: match.isMatchComplete()
                                    ? Colors.grey
                                    : Colors.deepOrangeAccent,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${match.playerIds.length.toString()}/${match.totalSlots.toString()}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Column(
                              children: <Widget>[ Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  match.name,
                                  style: priceTextStyle,
                                ),
                              ),],
                            ),
                          ),
                        ],
                      ),
                      ListTile(
                        title: Text(
                          "${_getReadableDate(match.date)} - ${match.time}",
                          style: titleTextStyle,
                        ),
                        subtitle: Text(match.arena.name),
                        trailing: Container(
                          decoration: BoxDecoration(
                              color: Colors.deepOrangeAccent,
                              shape: BoxShape.circle),
                          child: Transform.rotate(
                            angle: 25 * 3.1416 / 180,
                            child: IconButton(
                              icon: Icon(Icons.navigation),
                              onPressed: () {
                                MapsLauncher.launchQuery(match.arena.location);
                              },
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

final TextStyle priceTextStyle = const TextStyle(
  color: Colors.black,
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
);

final TextStyle titleTextStyle = const TextStyle(
  color: Colors.black,
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
);
