import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/tasbeeh_controller.dart';
import '../widgets/counter_controlls.dart';
import '../widgets/tasbeeh_background.dart';
import '../widgets/animated_counter.dart';
import '../widgets/circular_progress.dart';
import '../widgets/celebration_overlay.dart';

class TasbeehCounterScreen extends GetView<TasbeehController> {
  const TasbeehCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0A0E0A),
                    Color(0xFF1A2A1F),
                    Color(0xFF0B8A5E),
                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF8FAF9),
                    Color(0xFFE8F5EE),
                    Color(0xFFD4EDDA),
                  ],
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              _buildAppBar(context),
              // Body
              Expanded(
                child: Stack(
                  children: [
                    TasbeehBackground(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Obx(() {
                          if (controller.currentSession.value == null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Column(
                            children: [
                              // Step indicator
                              _buildStepIndicator(context),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () => Text(
                                      controller.currentDhikrName.value,
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF0B8A5E),
                                      ),
                                    ),
                                  ),
                                  Obx(
                                    () => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF0B8A5E,
                                        ).withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Target: ${controller.targetCount.value}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF0B8A5E),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              // Circular progress with counter inside
                              Expanded(
                                child: Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Obx(
                                        () => CircularProgress(
                                          progress: controller.progress.value,
                                          size: 240,
                                        ),
                                      ),
                                      Obx(
                                        () => AnimatedCounter(
                                          count: controller.count.value,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Controls at bottom
                              const CounterControls(),
                              const SizedBox(height: 8),
                              Text(
                                'Tap anywhere to count',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: isDark
                                      ? Colors.white54
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                    const CelebrationOverlay(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.find<TasbeehController>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2A1F) : Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : const Color(0xFF0B8A5E).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF0B8A5E), Color(0xFFD4AF37)],
              ),
            ),
            child: const Center(
              child: Icon(Icons.star_half, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(
              () => Text(
                controller.currentDhikrName.value,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0B8A5E),
                  letterSpacing: 0.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close_rounded,
              color: isDark ? Colors.white70 : const Color(0xFF6C757D),
              size: 28,
            ),
            onPressed: () => _showCancelDialog(context),
            tooltip: 'Cancel Session',
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      final session = controller.currentSession.value;
      if (session == null) return const SizedBox.shrink();
      final totalSteps = session.steps.length;
      final currentStep = session.currentStepIndex + 1;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Step $currentStep of $totalSteps',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isDark ? Colors.white60 : Colors.grey[600],
            ),
          ),
          const SizedBox(width: 12),
          ...List.generate(totalSteps, (index) {
            final isCompleted = session.steps[index].isCompleted;
            final isActive = index == session.currentStepIndex;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 24,
              height: 5,
              decoration: BoxDecoration(
                gradient: isCompleted
                    ? const LinearGradient(
                        colors: [Color(0xFF0B8A5E), Color(0xFFD4AF37)],
                      )
                    : isActive
                    ? LinearGradient(
                        colors: [
                          const Color(0xFF0B8A5E),
                          const Color(0xFF0B8A5E).withOpacity(0.5),
                        ],
                      )
                    : LinearGradient(
                        colors: isDark
                            ? [Colors.white10, Colors.white10]
                            : [Colors.grey[200]!, Colors.grey[200]!],
                      ),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ],
      );
    });
  }

  void _showCancelDialog(BuildContext context) {
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
                  Icons.warning_rounded,
                  color: Colors.red,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Cancel Session?',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your progress will be discarded.\nAre you sure you want to cancel?',
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
                        'Continue',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.cancelSession();
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
                        'Cancel & Discard',
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
