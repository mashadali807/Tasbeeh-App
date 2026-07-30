import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasbeeh/features/home/controller/home_controller.dart';
import '../widgets/greeting_widget.dart';
import '../widgets/progress_card.dart';
import '../widgets/streak_card.dart';
import '../widgets/continue_dhikr_card.dart';
import '../widgets/quote_card.dart';
import '../widgets/quick_actions.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dhikr Companion'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GreetingWidget(),
              const SizedBox(height: 16),
              const ProgressCard(),
              const SizedBox(height: 12),
              const StreakCard(),
              const SizedBox(height: 12),
              const ContinueDhikrCard(),
              const SizedBox(height: 12),
              const QuoteCard(),
              const SizedBox(height: 16),
              const Text(
                'Quick Actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const QuickActions(),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }
}
