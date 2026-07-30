import 'package:flutter/material.dart';

class AnimatedCounter extends StatelessWidget {
  final int count;

  const AnimatedCounter({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: IntTween(begin: 0, end: count),
      duration: const Duration(milliseconds: 300),
      builder: (context, int value, child) {
        return Text(
          value.toString(),
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: 80,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        );
      },
    );
  }
}
