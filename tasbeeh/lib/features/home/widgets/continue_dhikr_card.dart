import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh/features/home/controller/home_controller.dart';
import 'package:tasbeeh/features/tasbeeh/controllers/tasbeeh_controller.dart';
import 'package:tasbeeh/features/tasbeeh/models/tasbeeh_session.dart';

class ContinueDhikrCard extends StatelessWidget {
  const ContinueDhikrCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final homeController = Get.find<HomeController>();

    // ✅ Safe check: only try to get TasbeehController if it's registered
    TasbeehSession? activeSession;
    if (Get.isRegistered<TasbeehController>()) {
      final tasbeehController = Get.find<TasbeehController>();
      activeSession = tasbeehController.currentSession.value;
    }

    return Card(
      elevation: 6,
      shadowColor: isDark
          ? Colors.black54
          : const Color(0xFF0B8A5E).withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        onTap: homeController.resumeLastDhikr,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF1A2A1F),
                      const Color(0xFF0B8A5E).withOpacity(0.3),
                    ]
                  : [const Color(0xFFE8F5EE), const Color(0xFFD4EDDA)],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF0B8A5E).withOpacity(0.3)
                  : const Color(0xFF0B8A5E).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Icon with gradient background
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0B8A5E), Color(0xFFD4AF37)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0B8A5E).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activeSession != null
                            ? 'Resume Dhikr'
                            : 'Continue Last Dhikr',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0B8A5E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (activeSession != null) ...[
                        Row(
                          children: [
                            Text(
                              activeSession!.dhikrName,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0B8A5E).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${activeSession!.currentCount}/${activeSession!.targetCount}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0B8A5E),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Tap to continue where you left off',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: isDark ? Colors.white54 : Colors.grey[600],
                          ),
                        ),
                      ] else ...[
                        Text(
                          'Tap to resume your last session',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: isDark ? Colors.white54 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Arrow
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: isDark ? Colors.white54 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
