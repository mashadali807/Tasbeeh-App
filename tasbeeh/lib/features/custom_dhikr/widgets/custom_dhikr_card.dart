import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/custom_dhikr_model.dart';
import '../controllers/custom_dhikr_controller.dart';

class CustomDhikrCard extends StatelessWidget {
  final CustomDhikr dhikr;

  const CustomDhikrCard({super.key, required this.dhikr});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomDhikrController>();
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dhikr.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  if (dhikr.arabic != null && dhikr.arabic!.isNotEmpty)
                    Text(dhikr.arabic!, style: const TextStyle(fontSize: 18)),
                  Text(
                    'Target: ${dhikr.targetCount}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.play_arrow, color: Colors.green),
                  onPressed: () => controller.startDhikr(dhikr),
                  tooltip: 'Start Dhikr',
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => controller.openForm(dhikr: dhikr),
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteDialog(context, dhikr.id),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Dhikr?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.find<CustomDhikrController>().deleteDhikr(id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
