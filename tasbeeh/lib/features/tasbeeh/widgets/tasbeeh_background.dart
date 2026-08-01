import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/tasbeeh_controller.dart';

class TasbeehBackground extends StatelessWidget {
  final Widget child;

  const TasbeehBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TasbeehController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: controller.incrementCount,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF0A0E0A),
                    const Color(0xFF1A2A1F),
                    const Color(0xFF0B8A5E).withOpacity(0.2),
                  ]
                : [
                    const Color(0xFFF8FAF9),
                    const Color(0xFFE8F5EE),
                    const Color(0xFFD4EDDA).withOpacity(0.5),
                  ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Subtle decorative background elements
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFD4AF37).withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF0B8A5E).withOpacity(0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Main content
            child,
          ],
        ),
      ),
    );
  }
}
