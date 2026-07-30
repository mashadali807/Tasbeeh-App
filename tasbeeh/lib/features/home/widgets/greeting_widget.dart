import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:tasbeeh/features/home/controller/home_controller.dart';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(
      () => Card(
        elevation: 6,
        shadowColor: isDark ? Colors.white10 : Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF1A2A1F),
                      const Color(0xFF0B8A5E).withOpacity(0.3),
                    ]
                  : [
                      const Color(0xFFF8FAF9),
                      const Color(0xFF0B8A5E).withOpacity(0.08),
                    ],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getGreetingIcon(controller.greeting.value),
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      controller.greeting.value,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                controller.userName.value,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildDateItem(
                    context,
                    icon: Icons.calendar_today_outlined,
                    label: _getGregorianDate(),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 16),
                  _buildDateItem(
                    context,
                    icon: Icons.star_outline,
                    label: _getHijriDate(),
                    isDark: isDark,
                    isHijri: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isDark,
    bool isHijri = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: isDark ? Colors.white54 : Colors.black54),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: isDark ? Colors.white70 : Colors.black87,
            fontWeight: isHijri ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  IconData _getGreetingIcon(String greeting) {
    if (greeting.contains('Morning')) return Icons.wb_sunny_outlined;
    if (greeting.contains('Afternoon')) return Icons.wb_twilight_outlined;
    if (greeting.contains('Evening')) return Icons.nights_stay_outlined;
    return Icons.wb_sunny_outlined;
  }

  String _getGregorianDate() {
    final now = DateTime.now();
    final formatter = DateFormat('d MMM yyyy');
    return formatter.format(now);
  }

  String _getHijriDate() {
    final now = DateTime.now();
    final hijri = HijriCalendar.fromDate(now);
    // List of Hijri month names (index 0 is a placeholder for 1-based month)
    const monthNames = [
      '', // dummy at index 0
      'Muharram',
      'Safar',
      "Rabi' al-Awwal",
      "Rabi' al-Thani",
      'Jumada al-Ula',
      'Jumada al-Thani',
      'Rajab',
      "Sha'ban",
      'Ramadan',
      'Shawwal',
      'Dhu al-Qa\'dah',
      'Dhu al-Hijjah',
    ];
    return '${hijri.hDay} ${monthNames[hijri.hMonth]} ${hijri.hYear}';
  }
}
