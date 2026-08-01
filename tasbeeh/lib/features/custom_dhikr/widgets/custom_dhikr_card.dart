import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/custom_dhikr_model.dart';
import '../controllers/custom_dhikr_controller.dart';

class CustomDhikrCard extends StatelessWidget {
  final CustomDhikr dhikr;

  const CustomDhikrCard({super.key, required this.dhikr});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomDhikrController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Dhikr info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dhikr.name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0B8A5E),
                        letterSpacing: 0.3,
                      ),
                    ),
                    if (dhikr.arabic != null && dhikr.arabic!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        dhikr.arabic!,
                        style: GoogleFonts.amiri(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B8A5E).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Target: ${dhikr.targetCount}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF0B8A5E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Action buttons
              Row(
                children: [
                  _buildActionButton(
                    context,
                    icon: Icons.play_arrow_rounded,
                    color: const Color(0xFF0B8A5E),
                    tooltip: 'Start Dhikr',
                    onPressed: () => controller.startDhikr(dhikr),
                  ),
                  _buildActionButton(
                    context,
                    icon: Icons.edit_rounded,
                    color: const Color(0xFFD4AF37),
                    tooltip: 'Edit',
                    onPressed: () => controller.openForm(dhikr: dhikr),
                  ),
                  _buildActionButton(
                    context,
                    icon: Icons.delete_rounded,
                    color: Colors.red,
                    tooltip: 'Delete',
                    onPressed: () => _showDeleteDialog(context, dhikr.id),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: tooltip,
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isDark ? Colors.white10 : Colors.grey[50],
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark ? Colors.white24 : Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: IconButton(
          icon: Icon(icon, color: color, size: 22),
          onPressed: onPressed,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String id) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2A1E) : Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.red,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Delete Dhikr?',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This action cannot be undone.\nAre you sure you want to delete this dhikr?',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark
                            ? Colors.white70
                            : Colors.grey[600],
                        side: BorderSide(
                          color: isDark ? Colors.white24 : Colors.grey[300]!,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.find<CustomDhikrController>().deleteDhikr(id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Delete',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
