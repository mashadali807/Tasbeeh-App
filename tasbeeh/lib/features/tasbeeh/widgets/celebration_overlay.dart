import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tasbeeh_controller.dart';

class CelebrationOverlay extends StatelessWidget {
  const CelebrationOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TasbeehController>();
    return Obx(() {
      if (!controller.showCelebration.value) return const SizedBox.shrink();
      return PopScope(
        canPop: false,
        child: Container(
          color: Colors.black.withOpacity(0.6),
          child: Center(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              margin: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      size: 80,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '🎉 Goal Achieved! 🎉',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Text(
                        controller.allStepsCompleted.value
                            ? 'All steps completed! Masha\'Allah!'
                            : 'Step completed! Continue with the next one?',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => Text(
                        'Count: ${controller.count.value} / ${controller.targetCount.value}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: controller.saveAndFinish,
                            icon: const Icon(Icons.save),
                            label: const Text('Save & Finish'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: controller.discardAndCancel,
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('Discard'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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
          ),
        ),
      );
    });
  }
}
