import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/dhikr_library_controller.dart';
import '../widgets/dhikr_card.dart';
import '../widgets/search_bar.dart';

class DhikrLibraryScreen extends GetView<DhikrLibraryController> {
  final TextEditingController _searchController = TextEditingController();

  DhikrLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0A0E0A),
                    Color(0xFF1A2A1F),
                    Color(0xFF0B8A5E),
                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF8FAF9),
                    Color(0xFFE8F5EE),
                    Color(0xFFD4EDDA),
                  ],
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A2A1F) : Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.3)
                          : const Color(0xFF0B8A5E).withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0B8A5E), Color(0xFFD4AF37)],
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.book, color: Colors.white, size: 22),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Dhikr Library',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0B8A5E),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.search_rounded,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF6C757D),
                      ),
                      onPressed: () {
                        // Focus the search field
                        _searchController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _searchController.text.length,
                        );
                      },
                      tooltip: 'Search',
                    ),
                  ],
                ),
              ),
              // Body
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    children: [
                      // Search Bar
                      DhikrSearchBar(
                        controller: _searchController,
                        onChanged: controller.updateSearch,
                        onFilterToggle: controller.toggleFavoritesFilter,
                        showFavoritesOnly: controller.showFavoritesOnly.value,
                      ),
                      // List
                      Expanded(
                        child: controller.filteredDhikr.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.bookmark_border,
                                      size: 64,
                                      color: isDark
                                          ? Colors.white30
                                          : Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      controller.showFavoritesOnly.value
                                          ? 'No favorites yet.'
                                          : 'No Dhikr found.',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: isDark
                                            ? Colors.white60
                                            : Colors.grey[600],
                                      ),
                                    ),
                                    if (controller.showFavoritesOnly.value) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        'Tap the heart icon to save your favorites.',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: isDark
                                              ? Colors.white30
                                              : Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
