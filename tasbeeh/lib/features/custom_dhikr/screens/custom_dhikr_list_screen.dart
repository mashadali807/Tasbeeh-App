import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/custom_dhikr_controller.dart';
import '../widgets/custom_dhikr_card.dart';

class CustomDhikrListScreen extends GetView<CustomDhikrController> {
  const CustomDhikrListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dhikr'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: controller.syncFromFirestore,
            tooltip: 'Sync from Cloud',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.openForm(),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.dhikrList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No custom dhikr yet.'),
                SizedBox(height: 8),
                Text('Tap the + button to create one.'),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.dhikrList.length,
          itemBuilder: (context, index) {
            final dhikr = controller.dhikrList[index];
            return CustomDhikrCard(dhikr: dhikr);
          },
        );
      }),
    );
  }
}
