import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dhikr_library_controller.dart';
import '../widgets/dhikr_card.dart';
import '../widgets/search_bar.dart';

class DhikrLibraryScreen extends GetView<DhikrLibraryController> {
  final TextEditingController _searchController = TextEditingController();

  DhikrLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dhikr Library')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            DhikrSearchBar(
              controller: _searchController,
              onChanged: controller.updateSearch,
              onFilterToggle: controller.toggleFavoritesFilter,
              showFavoritesOnly: controller.showFavoritesOnly.value,
            ),
            Expanded(
              child: controller.filteredDhikr.isEmpty
                  ? const Center(child: Text('No Dhikr found.'))
                  : ListView.builder(
                      itemCount: controller.filteredDhikr.length,
                      itemBuilder: (context, index) {
                        final dhikr = controller.filteredDhikr[index];
                        final isFav = controller.isFavorite(dhikr.id);
                        return DhikrCard(
                          dhikr: dhikr,
                          isFavorite: isFav,
                          onFavoriteToggle: () =>
                              controller.toggleFavorite(dhikr.id),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}
