import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
          gradient: RadialGradient(
            center: const Alignment(0, -0.2),
            radius: 1.5,
            colors: isDark
                ? [
                    const Color(0xFF1A2A1F),
                    const Color(0xFF0A0E0A),
                    const Color(0xFF0B8A5E).withOpacity(0.2),
                  ]
                : [
                    const Color(0xFFF8FAF9),
                    const Color(0xFFFFFFFF),
                    const Color(0xFFD4EDDA).withOpacity(0.3),
                  ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: Center(
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutQuad,
            builder: (context, double scale, child) {
              return Transform.scale(
                scale: scale,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Premium Logo with emerald/gold ring and star
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            primaryColor.withOpacity(0.2),
                            goldColor.withOpacity(0.4),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: goldColor, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: goldColor.withOpacity(0.2),
                            blurRadius: 30,
                            spreadRadius: 5,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white10,
                        ),
                        child: Icon(
                          Icons.star_half_rounded,
                          size: 72,
                          color: goldColor,
                          shadows: [
                            Shadow(
                              color: goldColor.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // App name with gold accent
                    Text(
                      'Dhikr Companion',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        letterSpacing: 2.0,
                        shadows: [
                          Shadow(
                            color: primaryColor.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Smart Tasbeeh & Daily Dhikr',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: isDark ? Colors.white70 : Colors.black54,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Custom loading indicator with gradient
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [primaryColor, goldColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
