import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.currentDhikrName.value)),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _showCancelDialog(context),
            tooltip: 'Cancel Session',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCustomDhikrDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Custom Dhikr'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: [
          TasbeehBackground(
            child: SafeArea(
              child: Obx(() {
                if (controller.currentSession.value == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Step indicator
                      _buildStepIndicator(context),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => Text(
                            controller.currentDhikrName.value,
                            style: Theme.of(context).textTheme.titleLarge,
                          )),
                          Obx(() => Text(
                            'Target: ${controller.targetCount.value}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          )),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Circular progress with counter inside
                      Expanded(
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Obx(() => CircularProgress(
                                progress: controller.progress.value,
                                size: 220,
                              )),
                              Obx(() => AnimatedCounter(
                                count: controller.count.value,
                              )),
                            ],
                          ),
                        ),
                      ),
                      // Controls at bottom
                      const CounterControls(),
                      const SizedBox(height: 8),
                      Text(
                        'Tap anywhere to count',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const CelebrationOverlay(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(BuildContext context) {
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
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(width: 8),
          ...List.generate(totalSteps, (index) {
            final isCompleted = session.steps[index].isCompleted;
            final isActive = index == session.currentStepIndex;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 20,
              height: 4,
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.green
                    : isActive
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ],
      );
    });
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Session?'),
        content: const Text(
          'Your progress will be saved. You can resume it later from the home screen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Continue'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.cancelSession(); // ✅ public method
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showAddCustomDhikrDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController targetController = TextEditingController(text: '33');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Dhikr'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Dhikr Name',
                hintText: 'e.g., SubhanAllah',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: targetController,
              decoration: const InputDecoration(
                labelText: 'Target Count',
                hintText: '33',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final target = int.tryParse(targetController.text.trim()) ?? 33;
              if (name.isNotEmpty) {
                // ✅ Use the public method from the controller
                controller.addCustomDhikr(name, target);
                Get.back();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}