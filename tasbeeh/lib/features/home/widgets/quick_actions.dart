import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasbeeh/features/home/controller/home_controller.dart';
import 'package:tasbeeh/routes/app_routes.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final actions = [
      {'icon': Icons.circle, 'label': 'Tasbeeh', 'route': '/tasbeeh'},
      {'icon': Icons.book, 'label': 'Dhikr Library', 'route': '/dhikr-library'},
      {
        'icon': Icons.access_time,
        'label': 'Prayer Times',
        'route': '/prayer-times',
      },
      {'icon': Icons.explore, 'label': 'Qibla', 'route': '/qibla'},
      {
        'icon': Icons.bookmark_add_outlined,
        'label': 'Custom Dhikr',
        'route': Routes.customDhikr,
      },
      {'icon': Icons.history, 'label': 'History', 'route': Routes.history},
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: actions.map((action) {
        return InkWell(
          onTap: () => controller.navigateTo(action['route'] as String),
          borderRadius: BorderRadius.circular(16),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  action['icon'] as IconData,
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 8),
                Text(
                  action['label'] as String,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
