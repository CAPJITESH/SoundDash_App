import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:firebase_core/firebase_core.dart';
class DatabaseService {
  final String? uid = FirebaseAuth.instance.currentUser?.uid;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addInHistory(Map<String, dynamic> songData) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await usersCollection
        .doc(uid)
        .collection('history')
        .where('title', isEqualTo: songData['title'])
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in querySnapshot.docs) {
        await documentSnapshot.reference
            .update({'timestamp': FieldValue.serverTimestamp()});
      }
    } else {
      songData['timestamp'] = FieldValue.serverTimestamp();
      await usersCollection.doc(uid).collection('history').add(songData);
    }
  }

  Stream<QuerySnapshot> getHistoryStream() {
    return usersCollection
        .doc(uid)
        .collection('history')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<bool> isFav(Map<String, dynamic> songData) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await usersCollection
        .doc(uid)
        .collection('favourite')
        .where('title', isEqualTo: songData['title'])
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addRemoveFav(Map<String, dynamic> songData, bool isFav) async {
    if (isFav) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await usersCollection
          .doc(uid)
          .collection('favourite')
          .where('title', isEqualTo: songData['title'])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
            in querySnapshot.docs) {
          await documentSnapshot.reference.delete();
          // print('Document with title $songD deleted.');
        }
      }
    } else {
      songData['timestamp'] = FieldValue.serverTimestamp();
      await usersCollection.doc(uid).collection('favourite').add(songData);
    }
  }

  Stream<QuerySnapshot> getFavStream() {
    return usersCollection
        .doc(uid)
        .collection('favourite')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
