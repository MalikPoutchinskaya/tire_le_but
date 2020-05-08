import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tirelebut/models/arena.dart';

class DatabaseServiceArena {
  // collection reference
  final CollectionReference _arenasCollection =
      Firestore.instance.collection('arenas');

  //create
  create(Arena arena) async {
    DocumentReference ref = await _arenasCollection
        .add({Arena.nameRef: arena.name, Arena.locationRef: arena.location});
    print(ref.documentID);
  }

  // update
  Future<void> updateArenaData(String id, String name) async {
    return await _arenasCollection.document(id).setData({
      Arena.nameRef: name,
    });
  }

  // arena list from snapshot
  List<Arena> _arenaListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      print(doc.data);
      return Arena(
        id: doc.documentID ?? 'id null',
        name: doc.data[Arena.nameRef] ?? '',
        location: doc.data[Arena.locationRef] ?? '',
      );
    }).toList();
  }

  // arena data from snapshots
  Arena _arenaDataFromSnapshot(DocumentSnapshot snapshot) {
    return Arena(
      id: snapshot.documentID,
      name: snapshot.data[Arena.nameRef],
      location: snapshot.data[Arena.locationRef] ?? '',
    );
  }

  // arena data from snapshots
  Arena arenaDataFromMap(Map<String, dynamic> map) {
    return Arena(
      id: map[Arena.idRef],
      name: map[Arena.nameRef],
      location: map[Arena.locationRef] ?? '',
    );
  }

  // get players stream
  Stream<List<Arena>> get arenas {
    return _arenasCollection.snapshots().map(_arenaListFromSnapshot);
  }

  // get arena doc stream
  Stream<Arena> getArena(String id) {
    return _arenasCollection
        .document(id)
        .snapshots()
        .map(_arenaDataFromSnapshot);
  }
}
