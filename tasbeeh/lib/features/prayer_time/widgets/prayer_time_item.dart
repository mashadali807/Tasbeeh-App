import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/prayer_time.dart';

class PrayerTimeItem extends StatelessWidget {
  final PrayerTime prayer;

  const PrayerTimeItem({super.key, required this.prayer});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    IconData getIcon(String name) {
      switch (name) {
        case 'Fajr':
          return Icons.wb_twilight;
        case 'Sunrise':
          return Icons.wb_sunny;
        case 'Dhuhr':
          return Icons.wb_sunny_outlined;
        case 'Asr':
          return Icons.wb_twilight_outlined;
        case 'Maghrib':
          return Icons.nights_stay;
        case 'Isha':
          return Icons.nightlight_round;
        default:
          return Icons.access_time;
      }
    }

    Color getStatusColor() {
      if (prayer.isCurrent) return const Color(0xFF0B8A5E); // emerald
      if (prayer.isNext) return const Color(0xFFD4AF37); // gold
      if (prayer.isPast) return isDark ? Colors.white38 : Colors.grey[400]!;
      return isDark ? Colors.white38 : Colors.grey[400]!;
    }

    Color getBackgroundColor() {
      if (prayer.isCurrent) return const Color(0xFF0B8A5E).withOpacity(0.12);
      if (prayer.isNext) return const Color(0xFFD4AF37).withOpacity(0.12);
      return Colors.transparent;
    }

    Color getBorderColor() {
      if (prayer.isCurrent) return const Color(0xFF0B8A5E).withOpacity(0.4);
      if (prayer.isNext) return const Color(0xFFD4AF37).withOpacity(0.4);
      return Colors.transparent;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: getBackgroundColor(),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: getBorderColor(), width: 1.5),
        boxShadow: (prayer.isCurrent || prayer.isNext)
            ? [
                BoxShadow(
                  color: getStatusColor().withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Icon with subtle background
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: getStatusColor().withOpacity(0.15),
            ),
            child: Icon(
              getIcon(prayer.name),
              color: getStatusColor(),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          // Prayer name
          Expanded(
            child: Text(
              prayer.name,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: prayer.isCurrent || prayer.isNext
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: prayer.isPast
                    ? (isDark ? Colors.white38 : Colors.grey[400])
                    : (isDark ? Colors.white : Colors.black87),
                letterSpacing: 0.3,
              ),
            ),
          ),
          // Time
          Text(
            prayer.formattedTime,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: prayer.isCurrent || prayer.isNext
                  ? FontWeight.w600
                  : FontWeight.w400,
              color: prayer.isPast
                  ? (isDark ? Colors.white38 : Colors.grey[400])
                  : (isDark ? Colors.white : Colors.black87),
            ),
          ),
          const SizedBox(width: 12),
          // Status badge
          if (prayer.isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0B8A5E), Color(0xFFD4AF37)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0B8A5E).withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'NOW',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          if (prayer.isNext && !prayer.isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFD4AF37).withOpacity(0.4),
                  width: 1,
                ),
              ),
              child: Text(
                'NEXT',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFD4AF37),
                  letterSpacing: 0.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
