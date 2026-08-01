import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/daily_adhkar_controller.dart';
import '../widgets/daily_adhkar_card.dart';
import '../widgets/category_tabs.dart';

class DailyAdhkarScreen extends GetView<DailyAdhkarController> {
  const DailyAdhkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Adhkar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: controller.syncFromFirestore,
            tooltip: 'Sync Favorites',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Adhkar...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: controller.updateSearch,
            ),
          ),
          // Category tabs
          const CategoryTabs(),
          // List - wrapped with Obx
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.filteredAdhkar.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No Adhkar found.'),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: controller.filteredAdhkar.length,
                itemBuilder: (context, index) {
                  final adhkar = controller.filteredAdhkar[index];
                  // ✅ Pass favorite status as a parameter
                  final isFav = controller.isFavorite(adhkar.id);
                  return DailyAdhkarCard(
                    adhkar: adhkar,
                    isFavorite: isFav,
                    onFavoriteToggle: () => controller.toggleFavorite(adhkar.id),
                    onTap: () => controller.navigateToDetail(adhkar),
                    onStartDhikr: () => controller.startDhikr(adhkar),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}