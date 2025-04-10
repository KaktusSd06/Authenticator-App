import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/auth_token.dart';

class TokenService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveTokensForUser(String uid, List<AuthToken> allTokens) async {
    final data = {
      'tokens': allTokens.map((token) => token.toJson()).toList(),
    };

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('userInfo')
        .doc('Info')
        .set(data, SetOptions(merge: true));
  }

  Future<List<AuthToken>> loadTokensForUser(String uid) async {
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('userInfo')
        .doc('Info')
        .get();

    final data = doc.data();
    if (data == null || !data.containsKey('tokens')) {
      return [];
    }

    final List tokensJson = data['tokens'];
    return tokensJson.map((json) => AuthToken.fromJson(json)).toList();
  }
}
