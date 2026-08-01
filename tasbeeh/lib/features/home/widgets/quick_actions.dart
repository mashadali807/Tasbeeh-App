import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh/features/home/controller/home_controller.dart';
import 'package:tasbeeh/routes/app_routes.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final actions = [
      {
        'icon': Icons.circle,
        'label': 'Tasbeeh',
        'route': '/tasbeeh',
        'color': const Color(0xFF0B8A5E),
      },
      {
        'icon': Icons.book,
        'label': 'Dhikr Library',
        'route': '/dhikr-library',
        'color': const Color(0xFFD4AF37),
      },
      {
        'icon': Icons.access_time,
        'label': 'Prayer Times',
        'route': Routes.prayerTimes,
        'color': const Color(0xFF2196F3),
      },
      {
        'icon': Icons.bar_chart,
        'label': 'Statistics',
        'route': Routes.statistics,
        'color': const Color(0xFF9C27B0),
      },
      {
        'icon': Icons.bookmark_add_outlined,
        'label': 'Custom Dhikr',
        'route': Routes.customDhikr,
        'color': const Color(0xFFFF6F00),
      },
      {
        'icon': Icons.history,
        'label': 'History',
        'route': Routes.history,
        'color': const Color(0xFFE91E63),
      },
      {
        'icon': Icons.notifications,
        'label': 'Reminders',
        'route': Routes.reminders,
        'color': const Color(0xFFFF5722),
      },
      // {'icon': Icons.bookmark_outlined, 'label': 'Daily Adhkar', 'route': Routes.dailyAdhkar, 'color': const Color(0xFF4CAF50)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        final icon = action['icon'] as IconData;
        final label = action['label'] as String;
        final route = action['route'] as String;
        final color = action['color'] as Color;

        return InkWell(
          onTap: () => controller.navigateTo(route),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [const Color(0xFF1E2A1E), const Color(0xFF2A3A2A)]
                    : [Colors.white, Colors.grey[50]!],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.grey[300]!,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, size: 28, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : Colors.black87,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
