import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/daily_adhkar_controller.dart';

class CategoryTabs extends StatelessWidget {
  const CategoryTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DailyAdhkarController>();
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Obx(() {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            final isSelected = controller.selectedCategory.value == category;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (_) => controller.selectCategory(category),
                selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                backgroundColor: Colors.grey[100],
                labelStyle: TextStyle(
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}