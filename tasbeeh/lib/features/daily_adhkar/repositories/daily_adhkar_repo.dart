import '../models/daily_adhkar_model.dart';

abstract class DailyAdhkarRepository {
  Future<List<DailyAdhkar>> getAdhkar();
  Future<Set<String>> getFavorites();
  Future<void> toggleFavorite(String adhkarId, bool isFavorite);
  Future<void> loadFavoritesFromFirestore();
}