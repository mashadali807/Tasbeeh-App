import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh/features/history/controller/history_controller.dart';
import '../widgets/history_section.dart';

class HistoryListScreen extends GetView<HistoryController> {
  const HistoryListScreen({super.key});

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
                        child: Icon(
                          Icons.history_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'History',
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
                    // Filter button (with gradient active state)
                    _buildFilterButton(context),
                    const SizedBox(width: 4),
                    // Sync button
                    IconButton(
                      icon: Icon(
                        Icons.sync_rounded,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF6C757D),
                      ),
                      onPressed: controller.syncFromFirestore,
                      tooltip: 'Sync from Cloud',
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

                  final grouped = controller.groupedEntries;
                  if (grouped.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_rounded,
                            size: 72,
                            color: isDark ? Colors.white30 : Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No History Yet',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white60 : Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start your first Dhikr to track your progress!',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: isDark ? Colors.white38 : Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.loadHistory,
                    color: const Color(0xFF0B8A5E),
                    backgroundColor: isDark
                        ? const Color(0xFF1E2A1E)
                        : Colors.white,
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 20),
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: grouped.entries.map((entry) {
                        return HistorySection(
                          title: entry.key,
                          entries: entry.value,
                        );
                      }).toList(),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    final controller = Get.find<HistoryController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isActive = controller.showOnlyCompleted.value;

    return Obx(() {
      final isActive = controller.showOnlyCompleted.value;
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFF0B8A5E), Color(0xFFD4AF37)],
                )
              : null,
          color: isActive
              ? null
              : (isDark ? Colors.transparent : Colors.grey[100]),
          border: Border.all(
            color: isActive
                ? Colors.transparent
                : (isDark ? Colors.white24 : Colors.grey[300]!),
            width: 1,
          ),
        ),
        child: IconButton(
          icon: Icon(
            isActive ? Icons.filter_alt_rounded : Icons.filter_alt_outlined,
            color: isActive
                ? Colors.white
                : (isDark ? Colors.white60 : Colors.grey[600]),
            size: 22,
          ),
          onPressed: () => controller.showOnlyCompleted.toggle(),
          tooltip: 'Filter Completed Only',
          padding: EdgeInsets.zero,
        ),
      );
    });
  }
}
