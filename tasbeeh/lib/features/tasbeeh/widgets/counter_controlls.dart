import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tasbeeh_controller.dart';

class CounterControls extends StatelessWidget {
  const CounterControls({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TasbeehController>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.undo_rounded),
            onPressed: controller.undoCount,
            tooltip: 'Undo',
            iconSize: 32,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => _showResetDialog(context),
            tooltip: 'Reset',
            iconSize: 32,
          ),
          IconButton(
            icon: Obx(
                  () => Icon(
                controller.soundEnabled.value
                    ? Icons.volume_up_rounded
                    : Icons.volume_off_rounded,
              ),
            ),
            onPressed: () =>
                controller.toggleSound(!controller.soundEnabled.value),
            tooltip: 'Sound',
            iconSize: 32,
          ),
          IconButton(
            icon: Obx(
                  () => Icon(
                controller.vibrationEnabled.value
                    ? Icons.vibration_rounded
                    : Icons.vibration_outlined,
              ),
            ),
            onPressed: () =>
                controller.toggleVibration(!controller.vibrationEnabled.value),
            tooltip: 'Vibration',
            iconSize: 32,
          ),
          IconButton(
            icon: const Icon(Icons.cancel_rounded),
            onPressed: () => _showCancelDialog(context),
            tooltip: 'Cancel Session',
            iconSize: 32,
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Current Step?'),
        content: const Text('This will reset the count for the current Dhikr to 0.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.find<TasbeehController>().resetCount();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
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
              Get.find<TasbeehController>().cancelSession();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}