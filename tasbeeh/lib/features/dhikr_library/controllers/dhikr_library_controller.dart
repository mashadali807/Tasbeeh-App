import 'package:get/get.dart';
import '../models/dhikr_model.dart';
import '../repositories/dhikr_repository.dart';

class DhikrLibraryController extends GetxController {
  final DhikrRepository repository;

  RxList<Dhikr> allDhikr = <Dhikr>[].obs;
  RxList<Dhikr> filteredDhikr = <Dhikr>[].obs;
  RxString searchQuery = ''.obs;
  RxBool showFavoritesOnly = false.obs;
  RxSet<String> favoriteIds = <String>{}.obs;
  RxBool isLoading = true.obs;

  DhikrLibraryController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final dhikrList = await repository.getDhikrList();
      allDhikr.assignAll(dhikrList);
      await repository.loadFavoritesFromFirestore();
      final favs = await repository.getFavorites();
      favoriteIds.assignAll(favs);
      _applyFilters();
    } catch (e) {
      print('Error loading dhikr library: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite(String dhikrId) async {
    final isNowFavorite = !favoriteIds.contains(dhikrId);
    await repository.toggleFavorite(dhikrId, isNowFavorite);
    if (isNowFavorite) {
      favoriteIds.add(dhikrId);
    } else {
      favoriteIds.remove(dhikrId);
    }
    _applyFilters();
  }

  void updateSearch(String query) {
    searchQuery.value = query.toLowerCase();
    _applyFilters();
  }

  void toggleFavoritesFilter() {
    showFavoritesOnly.value = !showFavoritesOnly.value;
    _applyFilters();
  }

  void _applyFilters() {
    final query = searchQuery.value.trim().toLowerCase();
    // Start with a plain List
    List<Dhikr> list = allDhikr.toList();

    if (showFavoritesOnly.value) {
      list = list.where((dhikr) => favoriteIds.contains(dhikr.id)).toList();
    }

    if (query.isNotEmpty) {
      list = list.where((dhikr) {
        return dhikr.arabic.contains(query) ||
            dhikr.transliteration.toLowerCase().contains(query) ||
            dhikr.translationEn.toLowerCase().contains(query);
      }).toList();
    }

    filteredDhikr.assignAll(list);
  }

  bool isFavorite(String dhikrId) => favoriteIds.contains(dhikrId);
}
