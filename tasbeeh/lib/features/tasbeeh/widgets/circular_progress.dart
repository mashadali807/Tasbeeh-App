import 'package:flutter/material.dart';

class CircularProgress extends StatelessWidget {
  final double progress;
  final double size;

  const CircularProgress({super.key, required this.progress, this.size = 180});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            strokeWidth: 8,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 1.0 ? Colors.green : Theme.of(context).primaryColor,
            ),
          ),
          // Target count label in center
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: progress >= 1.0 ? Colors.green : null,
                ),
              ),
              if (progress >= 1.0)
                const Text(
                  '✨ Complete!',
                  style: TextStyle(color: Colors.green),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
