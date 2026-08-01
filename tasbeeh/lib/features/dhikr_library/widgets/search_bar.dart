import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DhikrSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterToggle;
  final bool showFavoritesOnly;

  const DhikrSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onFilterToggle,
    required this.showFavoritesOnly,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E2A1E) : Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.grey[200]!,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.2)
                        : Colors.grey[200]!.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Search Dhikr...',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isDark ? Colors.white54 : Colors.grey[500],
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: isDark ? Colors.white54 : Colors.grey[500],
                    size: 22,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                ),
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                onChanged: onChanged,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Favorite filter button
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: showFavoritesOnly
                  ? const LinearGradient(
                      colors: [Color(0xFFD4AF37), Color(0xFF0B8A5E)],
                    )
                  : LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF2A3A2A), const Color(0xFF1E2A1E)]
                          : [Colors.grey[100]!, Colors.grey[50]!],
                    ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: showFavoritesOnly
                    ? const Color(0xFFD4AF37)
                    : (isDark ? Colors.white10 : Colors.grey[200]!),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: showFavoritesOnly
                      ? const Color(0xFF0B8A5E).withOpacity(0.3)
                      : (isDark
                            ? Colors.black.withOpacity(0.1)
                            : Colors.grey[200]!.withOpacity(0.3)),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                showFavoritesOnly
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: showFavoritesOnly
                    ? Colors.white
                    : (isDark ? Colors.white54 : Colors.grey[500]),
                size: 24,
              ),
              onPressed: onFilterToggle,
              tooltip: 'Show favorites only',
            ),
          ),
        ],
      ),
    );
  }
}
