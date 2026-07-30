import '../models/dhikr_model.dart';

abstract class DhikrRepository {
  Future<List<Dhikr>> getDhikrList();
  Future<Set<String>> getFavorites();
  Future<void> toggleFavorite(String dhikrId, bool isFavorite);
  Future<void> loadFavoritesFromFirestore();
}
