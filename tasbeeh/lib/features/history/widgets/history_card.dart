import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/history_entry.dart';

class HistoryCard extends StatelessWidget {
  final HistoryEntry entry;

  const HistoryCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompleted = entry.isCompleted;
    final statusColor = isCompleted
        ? const Color(0xFF0B8A5E)
        : const Color(0xFFFF6F00);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shadowColor: isDark ? Colors.black54 : statusColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF1E2A1E), const Color(0xFF2A3A2A)]
                : [Colors.white, const Color(0xFFF8FAF9)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status indicator bar
              Container(
                width: 5,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isCompleted
                        ? [const Color(0xFF0B8A5E), const Color(0xFFD4AF37)]
                        : [const Color(0xFFFF6F00), const Color(0xFFFFC107)],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.dhikrName,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0B8A5E),
                        letterSpacing: 0.3,
                      ),
                    ),
                    if (entry.arabicText != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        entry.arabicText!,
                        style: GoogleFonts.amiri(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    // ✅ FIX: Use Wrap instead of Row to avoid overflow
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _buildInfoChip(
                          '${entry.count}/${entry.targetCount}',
                          Icons.numbers_rounded,
                          isDark,
                        ),
                        _buildInfoChip(
                          entry.durationString,
                          Icons.timer_rounded,
                          isDark,
                        ),
                        _buildInfoChip(
                          entry.formattedTime,
                          Icons.access_time_rounded,
                          isDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Status badge (aligned to top)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isCompleted
                        ? [const Color(0xFF0B8A5E), const Color(0xFFD4AF37)]
                        : [const Color(0xFFFF6F00), const Color(0xFFFFC107)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  isCompleted ? 'DONE' : 'PARTIAL',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.grey[300]!,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: isDark ? Colors.white54 : Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
