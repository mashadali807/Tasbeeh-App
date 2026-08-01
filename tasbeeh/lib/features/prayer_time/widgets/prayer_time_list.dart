import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh/features/prayer_time/controller/prayer_times_controller.dart';
import 'prayer_time_item.dart';

class PrayerTimeList extends StatelessWidget {
  const PrayerTimeList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PrayerTimesController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final data = controller.prayerTimes.value;
      if (data == null) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with location and date
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? Colors.white10
                        : const Color(0xFF0B8A5E).withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.location_on_rounded,
                    color: isDark ? Colors.white60 : const Color(0xFF0B8A5E),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    data.cityName,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF0B8A5E),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    data.date.toIso8601String().split('T').first,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: isDark ? Colors.white60 : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Decorative divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              color: isDark ? Colors.white24 : Colors.grey[300],
              thickness: 1,
              height: 24,
            ),
          ),
          const SizedBox(height: 8),
          // Prayer list
          ...data.prayers.map((prayer) => PrayerTimeItem(prayer: prayer)),
        ],
      );
    });
  }
}
