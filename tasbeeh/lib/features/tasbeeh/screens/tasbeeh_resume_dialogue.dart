import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TasbeehResumeDialog extends StatelessWidget {
  final String dhikrName;
  final int count;
  final int target;

  const TasbeehResumeDialog({
    super.key,
    required this.dhikrName,
    required this.count,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Continue Dhikr?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('You have an unfinished session:'),
          const SizedBox(height: 8),
          Text(
            '📿 $dhikrName',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('Progress: $count / $target'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Get.back(result: true),
          child: const Text('Continue'),
        ),
      ],
    );
  }
}
