import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donor_model.dart';
import 'package:firebase_auth/firebase_auth.dart';


class DonorProvider extends ChangeNotifier {
  final FirebaseFirestore _fire = FirebaseFirestore.instance;

  List<DonorModel> donors = [];
  StreamSubscription<QuerySnapshot>? _sub;

  // 🔥 START LISTENING TO DONORS
  void startListening() {
    debugPrint('👂 START LISTENING TO DONORS');

    _sub?.cancel();

    _sub = _fire
        .collection('donors')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      debugPrint('📥 DONORS FETCHED: ${snapshot.docs.length}');
      for (var d in donors) {
  debugPrint("Donor: ${d.name} - ${d.bloodGroup}");
}

      donors = snapshot.docs
          .map(
            (d) => DonorModel.fromMap(
              d.id,
              d.data() as Map<String, dynamic>,
            ),
          )
          .toList();

      notifyListeners();
    }, onError: (e) {
      debugPrint('❌ DONOR LISTEN ERROR: $e');
    });
  }

  // ➕ ADD DONOR
  Future<void> addDonor({
    required String name,
    required String bloodGroup,
    required String location,
    required String phone,
    required String emergencyContact,
  }) async {
    debugPrint('🩸 ADDING DONOR TO FIRESTORE');

    final user = FirebaseAuth.instance.currentUser;

await _fire.collection('donors').add({
  'userId': user?.uid,
  'name': name,
  'bloodGroup': bloodGroup,
  'location': location,
  'phone': phone,
  'emergencyContact': emergencyContact,
  'createdAt': FieldValue.serverTimestamp(),
});

    debugPrint('✅ DONOR SAVED');
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
