import 'package:cloud_firestore/cloud_firestore.dart';

class SynchronizeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> cancelSynchronize(String uid) async {
    final data = {
      'sync': false,
    };

    await _firestore
        .collection('users')
        .doc(uid)
        .set(data);
  }

  Future<void> startSynchronize(String uid) async {
    final data = {
      'sync': true,
    };

    await _firestore
        .collection('users')
        .doc(uid)
        .set(data);
  }

  Future<bool> isSynchronizing(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        return data?['sync'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
