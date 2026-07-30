import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/custom_dhikr_model.dart';

class CustomDhikrStorage {
  static const String _boxName = 'custom_dhikr';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Box<String>> _openBox() async {
    return await Hive.openBox<String>(_boxName);
  }

  // Save a custom dhikr (local + firestore)
  Future<void> saveCustomDhikr(String userId, CustomDhikr dhikr) async {
    // Local – always succeeds
    final box = await _openBox();
    await box.put(dhikr.id, jsonEncode(dhikr.toJson()));

    // Firestore – ignore errors
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('custom_dhikr')
          .doc(dhikr.id)
          .set(dhikr.toJson(), SetOptions(merge: true));
    } catch (e) {
      // Silently ignore – data is already stored locally
      print('⚠️ Firestore save failed (will retry later): $e');
    }
  }

  // Get all custom dhikr – local only (fast, offline)
  Future<List<CustomDhikr>> getCustomDhikr(String userId) async {
    final box = await _openBox();
    final list = <CustomDhikr>[];
    for (var key in box.keys) {
      final jsonStr = box.get(key);
      if (jsonStr != null) {
        try {
          final data = jsonDecode(jsonStr);
          list.add(CustomDhikr.fromJson(data));
        } catch (_) {}
      }
    }
    return list;
  }

  // Delete a custom dhikr (local + firestore)
  Future<void> deleteCustomDhikr(String userId, String id) async {
    // Local – always succeeds
    final box = await _openBox();
    await box.delete(id);

    // Firestore – ignore errors
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('custom_dhikr')
          .doc(id)
          .delete();
    } catch (e) {
      print('⚠️ Firestore delete failed: $e');
    }
  }

  // Sync from Firestore (call on login or manually)
  Future<void> syncFromFirestore(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('custom_dhikr')
          .get();
      final box = await _openBox();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final dhikr = CustomDhikr.fromJson(data);
        await box.put(dhikr.id, jsonEncode(dhikr.toJson()));
      }
    } catch (e) {
      // Firestore not available – just skip
      print('⚠️ Firestore sync failed: $e');
    }
  }

  // Optional: retry all pending syncs (called when connectivity returns)
  Future<void> retryPendingSyncs(String userId) async {
    // In a real app, you'd maintain a queue of pending operations.
    // For simplicity, we just sync all again.
    await syncFromFirestore(userId);
  }
}
