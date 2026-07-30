import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/dhikr_model.dart';

class DhikrDetailScreen extends StatelessWidget {
  const DhikrDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Dhikr dhikr = Get.arguments as Dhikr;
    return Scaffold(
      appBar: AppBar(title: Text(dhikr.transliteration)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                dhikr.arabic,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            if (dhikr.transliteration.isNotEmpty)
              Text(
                dhikr.transliteration,
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
            const SizedBox(height: 12),
            Text(
              'Translation: ${dhikr.translationEn}',
              style: const TextStyle(fontSize: 16),
            ),
            if (dhikr.translationUr != null) ...[
              const SizedBox(height: 8),
              Text(
                'Urdu: ${dhikr.translationUr}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
            if (dhikr.benefits != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Benefits',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(dhikr.benefits!, style: const TextStyle(fontSize: 16)),
            ],
            const SizedBox(height: 24),
            // ✅ Fixed Row – no overflow
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Recommended: ${dhikr.recommendedCount} times',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed(
                      '/tasbeeh',
                      arguments: {
                        'dhikrId': dhikr.id,
                        'dhikrName': dhikr.transliteration,
                        'recommendedCount': dhikr.recommendedCount,
                      },
                    );
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Dhikr'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
