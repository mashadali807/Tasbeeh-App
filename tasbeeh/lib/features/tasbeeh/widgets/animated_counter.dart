import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedCounter extends StatelessWidget {
  final int count;

  const AnimatedCounter({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TweenAnimationBuilder(
      tween: IntTween(begin: 0, end: count),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      builder: (context, int value, child) {
        return ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF0B8A5E), Color(0xFFD4AF37)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            value.toString(),
            style: GoogleFonts.poppins(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Used as base for ShaderMask
              letterSpacing: 1.5,
              shadows: [
                Shadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : const Color(0xFF0B8A5E).withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
