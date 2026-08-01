import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/history_entry.dart';
import 'history_card.dart';

class HistorySection extends StatelessWidget {
  final String title;
  final List<HistoryEntry> entries;

  const HistorySection({super.key, required this.title, required this.entries});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with title and decorative line
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0B8A5E), Color(0xFFD4AF37)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0B8A5E),
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${entries.length}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white60 : Colors.grey[600],
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
            color: isDark ? Colors.white12 : Colors.grey[200],
            thickness: 1,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        // List of history cards
        ...entries.map((entry) => HistoryCard(entry: entry)),
        const SizedBox(height: 16),
      ],
    );
  }
}
