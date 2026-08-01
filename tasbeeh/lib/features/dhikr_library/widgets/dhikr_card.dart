import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh/features/dhikr_library/widgets/favourite_button.dart';
import '../models/dhikr_model.dart';

class DhikrCard extends StatelessWidget {
  final Dhikr dhikr;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const DhikrCard({
    super.key,
    required this.dhikr,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shadowColor: isDark
          ? Colors.black54
          : const Color(0xFF0B8A5E).withOpacity(0.1),
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
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          title: Text(
            dhikr.arabic,
            style: GoogleFonts.amiri(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0B8A5E),
              height: 1.4,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                dhikr.transliteration,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: isDark ? Colors.white70 : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dhikr.translationEn,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: isDark ? Colors.white60 : Colors.grey[700],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? Colors.white10 : Colors.grey[100],
            ),
            child: FavoriteButton(
              isFavorite: isFavorite,
              onPressed: onFavoriteToggle,
            ),
          ),
          onTap: () {
            Get.toNamed('/dhikr-detail', arguments: dhikr);
          },
        ),
      ),
    );
  }
}
