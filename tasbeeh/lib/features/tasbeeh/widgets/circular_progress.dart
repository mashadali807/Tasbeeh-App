import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CircularProgress extends StatelessWidget {
  final double progress;
  final double size;

  const CircularProgress({super.key, required this.progress, this.size = 180});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final clampedProgress = progress.clamp(0.0, 1.0);
    final isComplete = clampedProgress >= 1.0;

    // Colors for the progress ring
    final Color progressColor = isComplete
        ? const Color(0xFFD4AF37) // Gold when complete
        : Theme.of(context).primaryColor;

    final Color backgroundColor = isDark ? Colors.white10 : Colors.grey[200]!;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring with subtle shadow
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.5)
                      : progressColor.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          // Progress ring
          CircularProgressIndicator(
            value: clampedProgress,
            strokeWidth: 10,
            backgroundColor: backgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
          // Percentage text in center
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(clampedProgress * 100).toInt()}%',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isComplete ? const Color(0xFFD4AF37) : progressColor,
                  letterSpacing: 0.5,
                ),
              ),
              if (isComplete) ...[
                const SizedBox(height: 2),
                Text(
                  '✨ Complete!',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFD4AF37),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
