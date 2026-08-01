import 'package:get/get.dart';
import '../models/daily_adhkar_model.dart';
import '../repositories/daily_adhkar_repo.dart';

class DailyAdhkarController extends GetxController {
  final DailyAdhkarRepository repository;

  final RxList<DailyAdhkar> allAdhkar = <DailyAdhkar>[].obs;
  final RxList<DailyAdhkar> filteredAdhkar = <DailyAdhkar>[].obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxSet<String> favoriteIds = <String>{}.obs;
  final RxBool isLoading = true.obs;

  final List<String> categories = [
    'All',
    'Morning',
    'Evening',
    'Sleeping',
    'Eating',
    'Traveling',
    'General',
  ];

  DailyAdhkarController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final adhkar = await repository.getAdhkar();
      allAdhkar.assignAll(adhkar);
      await repository.loadFavoritesFromFirestore();
      final favs = await repository.getFavorites();
      favoriteIds.assignAll(favs);
      _applyFilters();
    } catch (e) {
      print('Error loading daily adhkar: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    _applyFilters();
  }

  void updateSearch(String query) {
    searchQuery.value = query.toLowerCase();
    _applyFilters();
  }

  void _applyFilters() {
    final query = searchQuery.value.trim().toLowerCase();
    List<DailyAdhkar> list = allAdhkar.toList();

    // Filter by category
    if (selectedCategory.value != 'All') {
      list = list.where((adhkar) => adhkar.category == selectedCategory.value.toLowerCase()).toList();
    }

    // Filter by search
    if (query.isNotEmpty) {
      list = list.where((adhkar) {
        return adhkar.arabic.contains(query) ||
            adhkar.transliteration.toLowerCase().contains(query) ||
            adhkar.translationEn.toLowerCase().contains(query);
      }).toList();
    }

    filteredAdhkar.assignAll(list);
  }

  Future<void> toggleFavorite(String adhkarId) async {
    final isNowFavorite = !favoriteIds.contains(adhkarId);
    await repository.toggleFavorite(adhkarId, isNowFavorite);
    if (isNowFavorite) {
      favoriteIds.add(adhkarId);
    } else {
      favoriteIds.remove(adhkarId);
    }
    _applyFilters();
  }

  bool isFavorite(String adhkarId) => favoriteIds.contains(adhkarId);

  void startDhikr(DailyAdhkar adhkar) {
    Get.toNamed('/tasbeeh', arguments: {
      'dhikrId': adhkar.id,
      'dhikrName': adhkar.transliteration,
      'recommendedCount': adhkar.recommendedCount,
    });
  }

  void navigateToDetail(DailyAdhkar adhkar) {
    Get.toNamed('/daily-adhkar-detail', arguments: adhkar);
  }

  // Sync from Firestore (manual pull)
  Future<void> syncFromFirestore() async {
    isLoading.value = true;
    try {
      await repository.loadFavoritesFromFirestore();
      final favs = await repository.getFavorites();
      favoriteIds.assignAll(favs);
      _applyFilters();
    } finally {
      isLoading.value = false;
    }
  }
}