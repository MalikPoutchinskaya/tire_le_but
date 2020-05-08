import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tirelebut/models/player.dart';

class DatabaseServicePlayer {
  final String uid;

  DatabaseServicePlayer({this.uid});

  // collection reference
  final CollectionReference playersCollection =
      Firestore.instance.collection('players');

  Future<void> updateUserData(String name, String style, int matchPlayed,
      String pictureUrl, List<dynamic> matchIds) async {
    print("---- update user -----");
    print("name: $name");
    print("style: $style");
    print("matchPlayed: $matchPlayed");
    print("pictureUrl: $pictureUrl");
    print("matchIds: $matchIds");
    return await playersCollection.document(uid).setData({
      Player.nameRef: name,
      Player.styleRef: style,
      Player.matchPlayedRef: matchPlayed,
      Player.pictureUrlRef: pictureUrl,
      Player.matchIdsRef: matchIds,
    });
  }

  Future<void> updateUserDataWithPlayer(Player player) async {
    return await playersCollection.document(player.id).setData({
      Player.nameRef: player.name,
      Player.styleRef: player.style,
      Player.matchPlayedRef: player.matchPlayed,
      Player.pictureUrlRef: player.pictureUrl,
      Player.matchIdsRef: player.matchIds,
    });
  }

  // player list from snapshot
  List<Player> _playerListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      print(doc.data);
      return _playerFromSnapshot(doc);
    }).toList();
  }

  // player from snapshots
  Player _playerFromSnapshot(DocumentSnapshot snapshot) {
    print("_playerFromSnapshot: $snapshot");
    print("_playerFromSnapshot: ${snapshot.documentID}");
    print("_playerFromSnapshot: ${snapshot.data[Player.nameRef]}");
    print("_playerFromSnapshot: ${snapshot.data[Player.styleRef]}");
    print("_playerFromSnapshot: ${snapshot.data[Player.matchPlayedRef]}");
    print("_playerFromSnapshot: ${snapshot.data[Player.pictureUrlRef]}");
    print("_playerFromSnapshot: ${snapshot.data[Player.matchIdsRef]}");

    return Player(
      id: snapshot.documentID ?? '',
      name: snapshot.data[Player.nameRef] ?? '',
      style: snapshot.data[Player.styleRef] ?? Player.tireur,
      matchPlayed: snapshot.data[Player.matchPlayedRef] ?? 0,
      pictureUrl: snapshot.data[Player.pictureUrlRef] ?? '',
      matchIds: snapshot.data[Player.matchIdsRef] ?? List<String>(),
    );
  }

  // player data from map
  Player playerDataFromMap(Map<String, dynamic> map) {
    print("playerDataFromMap: $map");
    return Player(
      id: map[Player.idRef] ?? '',
      name: map[Player.nameRef] ?? '',
      style: map[Player.styleRef] ?? Player.tireur,
      matchPlayed: map[Player.matchPlayedRef] ?? 0,
      pictureUrl: map[Player.pictureUrlRef] ?? '',
      matchIds: map[Player.matchIdsRef] ?? List<String>(),
    );
  }

  // get players stream
  Stream<List<Player>> get players {
    return playersCollection.snapshots().map(_playerListFromSnapshot);
  }

  Stream<List<Player>> getPlayersById(List<String> playerIds) {
    return playersCollection
        .where(FieldPath.documentId, whereIn: playerIds)
        .snapshots()
        .map(_playerListFromSnapshot);
  }

  // user doc stream
  Stream<Player> get user {
    return playersCollection.document(uid).snapshots().map(_playerFromSnapshot);
  }

  // player doc stream
  Stream<Player> getPlayer(String id) {
    return playersCollection.document(id).snapshots().map(_playerFromSnapshot);
  }
}
