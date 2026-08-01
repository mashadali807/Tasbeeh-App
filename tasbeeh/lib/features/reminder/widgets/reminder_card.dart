import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasbeeh/features/reminder/controllers/reminder_controller.dart';
import 'package:tasbeeh/routes/app_routes.dart';
import '../models/reminder_model.dart';

class ReminderCard extends StatelessWidget {
  final Reminder reminder;

  const ReminderCard({super.key, required this.reminder});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RemindersController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = reminder.isEnabled;
    final statusColor = isEnabled ? const Color(0xFF0B8A5E) : Colors.grey;

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon with gradient background
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isEnabled
                      ? const LinearGradient(
                          colors: [Color(0xFF0B8A5E), Color(0xFFD4AF37)],
                        )
                      : LinearGradient(
                          colors: [Colors.grey[400]!, Colors.grey[300]!],
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(_getIcon(), color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0B8A5E),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // ✅ Use Wrap to prevent overflow
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        _buildInfoRow(
                          Icons.access_time_rounded,
                          reminder.formattedTime,
                          isDark,
                        ),
                        _buildInfoRow(
                          Icons.calendar_today_rounded,
                          reminder.daysString,
                          isDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions + Toggle
              Row(
                children: [
                  // Popup menu (Edit / Delete)
                  PopupMenuButton<String>(
                    offset: const Offset(0, 40),
                    color: isDark ? const Color(0xFF2A3A2A) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isDark ? Colors.white24 : Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        Get.toNamed(Routes.customReminder, arguments: reminder);
                      } else if (value == 'delete') {
                        _showDeleteDialog(context, reminder.id);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'edit',
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_rounded,
                              color: const Color(0xFFD4AF37),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Edit',
                              style: GoogleFonts.poppins(
                                color: isDark ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_rounded,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Delete',
                              style: GoogleFonts.poppins(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? Colors.white24 : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.more_vert_rounded,
                        color: Color(0xFF6C757D),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Custom toggle switch
                  GestureDetector(
                    onTap: () => controller.toggleReminder(reminder.id),
                    child: Container(
                      width: 50,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: isEnabled
                            ? const LinearGradient(
                                colors: [Color(0xFF0B8A5E), Color(0xFFD4AF37)],
                              )
                            : LinearGradient(
                                colors: [
                                  isDark
                                      ? Colors.grey[700]!
                                      : Colors.grey[400]!,
                                  isDark
                                      ? Colors.grey[600]!
                                      : Colors.grey[300]!,
                                ],
                              ),
                        boxShadow: [
                          BoxShadow(
                            color: statusColor.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        margin: EdgeInsets.only(
                          left: isEnabled ? 22 : 2,
                          top: 2,
                          bottom: 2,
                        ),
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
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

  Widget _buildInfoRow(IconData icon, String text, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: isDark ? Colors.white54 : Colors.grey[500]),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: isDark ? Colors.white60 : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  IconData _getIcon() {
    switch (reminder.type) {
      case ReminderType.morningAdhkar:
        return Icons.wb_sunny_rounded;
      case ReminderType.eveningAdhkar:
        return Icons.nights_stay_rounded;
      case ReminderType.prayerTime:
        return Icons.access_time_rounded;
      case ReminderType.dailyGoal:
        return Icons.emoji_events_rounded;
      default:
        return Icons.notifications_rounded;
    }
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
                'Delete Reminder?',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This action cannot be undone.\nAre you sure you want to delete this reminder?',
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
                        Get.find<RemindersController>().deleteReminder(id);
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
