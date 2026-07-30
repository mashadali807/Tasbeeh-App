import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasbeeh/features/history/controller/history_controller.dart';
import '../widgets/history_section.dart';

class HistoryListScreen extends GetView<HistoryController> {
  const HistoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: controller.syncFromFirestore,
            tooltip: 'Sync from Cloud',
          ),
          Obx(
            () => IconButton(
              icon: Icon(
                controller.showOnlyCompleted.value
                    ? Icons.filter_alt
                    : Icons.filter_alt_outlined,
                color: controller.showOnlyCompleted.value
                    ? Theme.of(context).primaryColor
                    : null,
              ),
              onPressed: () => controller.showOnlyCompleted.toggle(),
              tooltip: 'Filter Completed Only',
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final grouped = controller.groupedEntries;
        if (grouped.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No History Yet',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Start your first Dhikr to track your progress!',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView(
          children: grouped.entries.map((entry) {
            return HistorySection(title: entry.key, entries: entry.value);
          }).toList(),
        );
      }),
    );
  }
}
