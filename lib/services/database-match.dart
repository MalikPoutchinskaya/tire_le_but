import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tirelebut/models/match.dart';

import 'database-arena.dart';

class DatabaseServiceMatch {
  // collection reference
  final CollectionReference _matchesCollection =
      Firestore.instance.collection('matches');

  //
  Future<String> create(Match match, String uid) async {
    match.slotsBooked = 1;
    match.ownerId = uid;
    match.playerIds = [];
    match.playerIds.add(uid);

    DocumentReference ref = await _matchesCollection.add({
      Match.nameRef: match.name,
      Match.dateRef: match.date,
      Match.timeRef: match.time,
      Match.totalSlotsRef: match.totalSlots,
      Match.slotsBookedRef: match.slotsBooked,
      Match.arenaRef: match.arena.toJson(),
      Match.ownerIdRef: match.ownerId,
      Match.playerIdsRef: match.playerIds,
    });
    print(ref.documentID);
    return ref.documentID;
  }

  //update
  Future<void> updateMatchPlayerIds(Match match, String playerId) async {
    match.playerIds.add(playerId);
    return await _matchesCollection.document(match.id).setData({
      Match.nameRef: match.name,
      Match.dateRef: match.date,
      Match.timeRef: match.time,
      Match.totalSlotsRef: match.totalSlots,
      Match.slotsBookedRef: match.slotsBooked,
      Match.arenaRef: match.arena.toJson(),
      Match.ownerIdRef: match.ownerId,
      Match.playerIdsRef: match.playerIds,
    });
  }

  // Match list from snapshot
  List<Match> _matchListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      print(doc.data);
      return _userDataFromSnapshot(doc);
    }).toList();
  }

  // Match data from snapshots
  Match _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return Match(
      id: snapshot.documentID,
      name: snapshot.data[Match.nameRef],
      date: snapshot.data[Match.dateRef],
      time: snapshot.data[Match.timeRef],
      totalSlots: snapshot.data[Match.totalSlotsRef],
      slotsBooked: snapshot.data[Match.slotsBookedRef],
      arena: DatabaseServiceArena().arenaDataFromMap(
          Map<String, dynamic>.from(snapshot.data[Match.arenaRef])),
      ownerId: snapshot.data[Match.ownerIdRef],
      playerIds: List.from(snapshot.data[Match.playerIdsRef]),
    );
  }

  // get all matches stream
  Stream<List<Match>> get matches {
    return _matchesCollection.snapshots().map(_matchListFromSnapshot);
  }

  // get my matches stream
  Stream<List<Match>> getMyMatches(List<dynamic> matchIds) {
    return _matchesCollection
        .where(FieldPath.documentId, whereIn: matchIds)
        .snapshots()
        .map(_matchListFromSnapshot);
  }

  // get user doc stream
  Stream<Match> getMatch(String id) {
    return _matchesCollection
        .document(id)
        .snapshots()
        .map(_userDataFromSnapshot);
  }
}
