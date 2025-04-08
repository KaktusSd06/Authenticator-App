import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveSubscriptionForUser({
    required String uid,
    required String email,
    required String plan,
    required String nextBilling,
    required bool hasFreeTrial,
  }) async {
    final data = {
      'email': email,
      'plan': plan,
      'nextBilling': nextBilling,
      'hasFreeTrial': hasFreeTrial,
      'premium': true,
    };
    await _firestore.collection('users').doc(uid).set(data);
  }

  Future<bool> isUserPremium(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.get('premium') ?? false;
  }

  Future<Map<String, dynamic>?> loadSubscriptionForUser(String uid) async {
    try {
      final snapshot = await _firestore.collection('users').doc(uid).get();
      if (snapshot.exists) {
        return snapshot.data();
      }
      return null;
    } catch (e) {
      print('Error fetching subscription: $e');
      return null;
    }
  }

  Future<void> cancelSubscription(String uid) async {
    final data = {
      'plan': null,
      'nextBilling': null,
      'premium': false,
    };
    await _firestore.collection('users').doc(uid).update(data);
  }
}
