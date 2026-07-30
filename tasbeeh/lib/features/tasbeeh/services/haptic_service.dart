import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class HapticService {
  Future<void> vibrate() async {
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator ?? false) {
        await Vibration.vibrate(duration: 20);
      }
    } on MissingPluginException catch (_) {
      // Vibration not available on this platform/emulator
    } catch (e) {
      print('Vibration error: $e');
    }
  }
}
