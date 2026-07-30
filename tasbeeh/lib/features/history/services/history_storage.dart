import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/history_entry.dart';

class HistoryStorage {
  static const String _boxName = 'history';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Box<String>> _openBox() async {
    return await Hive.openBox<String>(_boxName);
  }

  // Save a history entry
  Future<void> saveHistoryEntry(String userId, HistoryEntry entry) async {
    // Local
    final box = await _openBox();
    await box.put(entry.id, jsonEncode(entry.toJson()));

    // Firestore (best effort)
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('history')
          .doc(entry.id)
          .set(entry.toJson());
    } catch (e) {
      // Silently ignore – data is local
      print('⚠️ Firestore history save failed: $e');
    }
  }

  // Get all history entries (local)
  Future<List<HistoryEntry>> getHistoryEntries() async {
    final box = await _openBox();
    final list = <HistoryEntry>[];
    for (var key in box.keys) {
      final jsonStr = box.get(key);
      if (jsonStr != null) {
        try {
          final data = jsonDecode(jsonStr);
          list.add(HistoryEntry.fromJson(data));
        } catch (_) {}
      }
    }
    // Sort by date descending (newest first)
    list.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return list;
  }

  // Delete a history entry
  Future<void> deleteHistoryEntry(String userId, String id) async {
    final box = await _openBox();
    await box.delete(id);
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('history')
          .doc(id)
          .delete();
    } catch (e) {
      print('⚠️ Firestore delete failed: $e');
    }
  }

  // Sync from Firestore
  Future<void> syncFromFirestore(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('history')
          .orderBy('startedAt', descending: true)
          .get();
      final box = await _openBox();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final entry = HistoryEntry.fromJson(data);
        await box.put(entry.id, jsonEncode(entry.toJson()));
      }
    } catch (e) {
      print('⚠️ Firestore sync failed: $e');
    }
  }
}
