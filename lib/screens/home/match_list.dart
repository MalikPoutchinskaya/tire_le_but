import 'package:tirelebut/models/match.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'match_tile.dart';

class MatchList extends StatefulWidget {
  @override
  _MatchListState createState() => _MatchListState();
}

class _MatchListState extends State<MatchList> {
  @override
  Widget build(BuildContext context) {
    final _matches = Provider.of<List<Match>>(context) ?? [];

    return _matches.isEmpty ? Center(child: Text('No match available')) : ListView.builder(
      itemCount: _matches.length,
      itemBuilder: (context, index) {
        return MatchTile(match: _matches[index]);
      },
    );
  }
}
