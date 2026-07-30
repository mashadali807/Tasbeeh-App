import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/tasbeeh_controller.dart';

class CelebrationOverlay extends StatelessWidget {
  const CelebrationOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TasbeehController>();
    return Obx(() {
      if (!controller.showCelebration.value) return const SizedBox.shrink();
      return GestureDetector(
        onTap: () => controller.showCelebration.value = false,
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Use a working animation or fallback
                _buildCelebrationAnimation(),
                const SizedBox(height: 16),
                Text(
                  '🌟 Goal Achieved! 🌟',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Masha\'Allah! Keep going!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tap anywhere to dismiss',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCelebrationAnimation() {
    try {
      // Try to load from network first
      return Lottie.network(
        'https://assets10.lottiefiles.com/packages/lf20_j1adxtyb.json',
        width: 200,
        height: 200,
        repeat: true,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to icon if animation fails
          return const Icon(
            Icons.celebration,
            size: 100,
            color: Colors.amber,
          );
        },
      );
    } catch (e) {
      // Fallback if anything fails
      return const Icon(
        Icons.celebration,
        size: 100,
        color: Colors.amber,
      );
    }
  }
}