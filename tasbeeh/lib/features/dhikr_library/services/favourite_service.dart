import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteService {
  static const String _boxName = 'favorites';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Box<String>> _openBox() async {
    return await Hive.openBox<String>(_boxName);
  }

  Future<Set<String>> getFavorites(String userId) async {
    final box = await _openBox();
    final keys = box.keys.cast<String>().toList();
    final userFavs = <String>{};
    for (var key in keys) {
      if (key.startsWith('$userId:')) {
        final dhikrId = key.substring(userId.length + 1);
        userFavs.add(dhikrId);
      }
    }
    return userFavs;
  }

  Future<void> toggleFavorite(
    String userId,
    String dhikrId,
    bool isFavorite,
  ) async {
    final box = await _openBox();
    final key = '$userId:$dhikrId';
    if (isFavorite) {
      await box.put(key, dhikrId);
    } else {
      await box.delete(key);
    }
    // Sync to Firestore (ignore errors)
    await _syncFavoritesToFirestore(userId);
  }

  Future<void> _syncFavoritesToFirestore(String userId) async {
    try {
      final favorites = await getFavorites(userId);
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc('dhikr_favorites')
          .set({'favoriteIds': favorites.toList()}, SetOptions(merge: true));
    } catch (e) {
      // Permission denied or network error – we already have local copy
      print('⚠️ Sync favorites to Firestore failed: $e');
    }
  }

  Future<void> loadFavoritesFromFirestore(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc('dhikr_favorites')
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        final List<dynamic> ids = data['favoriteIds'] ?? [];
        final box = await _openBox();
        final keysToDelete = box.keys
            .where((key) => key.startsWith('$userId:'))
            .toList();
        for (var key in keysToDelete) {
          await box.delete(key);
        }
        for (var id in ids) {
          await box.put('$userId:$id', id);
        }
      }
    } catch (e) {
      print('⚠️ Load favorites from Firestore failed: $e');
      // Keep existing local favorites
    }
  }
}
