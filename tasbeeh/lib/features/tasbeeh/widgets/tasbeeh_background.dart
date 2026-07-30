import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tasbeeh_controller.dart';

class TasbeehBackground extends StatelessWidget {
  final Widget child;

  const TasbeehBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TasbeehController>();
    return GestureDetector(
      onTap: controller.incrementCount,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.05),
              Colors.transparent,
              Theme.of(context).primaryColor.withOpacity(0.1),
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}
