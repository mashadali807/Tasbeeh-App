import 'dart:async';
import 'package:get/get.dart';
import 'package:tasbeeh/features/prayer_time/repositories/prayer_time_repo.dart';
import '../models/prayer_time.dart';

class PrayerTimesController extends GetxController {
  final PrayerTimesRepository repository;

  final Rx<PrayerTimesData?> prayerTimes = Rx<PrayerTimesData?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<Duration> timeRemaining = const Duration().obs;
  Timer? _countdownTimer;

  PrayerTimesController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    loadPrayerTimes();
    _startCountdownTimer();
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    super.onClose();
  }

  Future<void> loadPrayerTimes({bool forceRefresh = false}) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final data = await repository.getPrayerTimes(forceRefresh: forceRefresh);
      prayerTimes.value = data;
      if (data.timeUntilNext != null) {
        timeRemaining.value = data.timeUntilNext!;
      }
    } catch (e) {
      errorMessage.value = 'Could not load prayer times. Please try again.';
      print('Error loading prayer times: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final current = prayerTimes.value;
      if (current?.nextPrayer != null) {
        final now = DateTime.now();
        final diff = current!.nextPrayer!.time.difference(now);
        if (diff.isNegative) {
          // Next prayer has passed – reload
          loadPrayerTimes(forceRefresh: true);
        } else {
          timeRemaining.value = diff;
        }
      }
    });
  }

  Future<void> refreshPrayerTimes() async {
    await loadPrayerTimes(forceRefresh: true);
  }
}
