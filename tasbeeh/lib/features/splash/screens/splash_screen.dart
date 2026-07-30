import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasbeeh/theme/dark_theme.dart';
import 'package:tasbeeh/theme/light_theme.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? DarkTheme.emerald : LightTheme.emerald;
    final goldColor = isDark ? DarkTheme.gold : LightTheme.gold;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF1A1A1A), const Color(0xFF0B8A5E).withOpacity(0.3)]
                : [const Color(0xFFFFFFFF), const Color(0xFF0B8A5E).withOpacity(0.1)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🎨 Custom Logo (no external assets)
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withOpacity(0.1),
                  border: Border.all(color: goldColor, width: 3),
                ),
                child: Icon(
                  Icons.star_half,
                  size: 70,
                  color: goldColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Dhikr Companion',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Smart Tasbeeh & Daily Dhikr',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white54 : Colors.black54,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 40),
              // Loading indicator
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(goldColor),
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}