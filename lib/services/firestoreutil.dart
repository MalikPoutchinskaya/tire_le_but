import 'package:cloud_firestore/cloud_firestore.dart';

class CrudFirestore {
  final databaseReference = Firestore.instance;

  ///
  void deleteData(String _collectionRef, String _id) {
    try {
      databaseReference
          .collection(_collectionRef)
          .document(_id)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  ///
  Stream<DocumentSnapshot> getData(String _collectionRef, String _id) {
    return databaseReference
        .collection(_collectionRef)
        .document(_id)
        .snapshots();
  }
}
