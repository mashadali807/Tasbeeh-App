import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh/features/statistics/models/static_summary.dart';

class SummaryCard extends StatelessWidget {
  final StatisticsSummary summary;

  const SummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shadowColor: isDark
          ? Colors.black54
          : const Color(0xFF0B8A5E).withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF1E2A1E), const Color(0xFF2A3A2A)]
                : [Colors.white, const Color(0xFFF8FAF9)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              context,
              label: 'Total',
              value: summary.totalCount.toString(),
              icon: Icons.numbers_rounded,
              isDark: isDark,
            ),
            _buildStatItem(
              context,
              label: 'Favorite',
              value: summary.favoriteDhikr,
              icon: Icons.favorite_rounded,
              isDark: isDark,
              isText: true,
            ),
            _buildStatItem(
              context,
              label: 'Streak',
              value: '${summary.longestStreak} days',
              icon: Icons.local_fire_department_rounded,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required bool isDark,
    bool isText = false,
  }) {
    return Column(
      children: [
        // Icon with gradient background
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF0B8A5E), Color(0xFFD4AF37)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0B8A5E).withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(height: 8),
        // Value
        if (isText)
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0B8A5E),
              letterSpacing: 0.3,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          )
        else
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0B8A5E),
              letterSpacing: 0.5,
            ),
          ),
        const SizedBox(height: 2),
        // Label
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white60 : Colors.grey[600],
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
