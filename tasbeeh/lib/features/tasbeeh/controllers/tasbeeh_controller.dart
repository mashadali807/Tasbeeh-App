import 'dart:async';
import 'package:get/get.dart';
import 'package:tasbeeh/features/history/repositories/history_repo.dart';
import '../../history/models/history_entry.dart';
import '../models/tasbeeh_session.dart';
import '../models/tasbeeh_step.dart';
import '../repositories/tasbeeh_repository.dart';

class TasbeehController extends GetxController {
  final TasbeehRepository repository;
  final HistoryRepository historyRepository;

  // ---------- Reactive State ----------
  final Rx<TasbeehSession?> currentSession = Rx<TasbeehSession?>(null);
  final RxInt count = 0.obs;
  final RxString currentDhikrName = ''.obs;
  final RxInt targetCount = 0.obs;
  final RxDouble progress = 0.0.obs;
  final RxBool isTargetReached = false.obs;
  final RxBool isCounting = false.obs;
  final RxBool showCelebration = false.obs;
  final RxBool allStepsCompleted = false.obs;

  final RxBool vibrationEnabled = true.obs;
  final RxBool soundEnabled = true.obs;

  // ---------- Internal State ----------
  Timer? _autoSaveTimer;
  bool _hasUnsavedChanges = false;
  bool _isSessionSaved = false; // prevent duplicate finalisation

  TasbeehController({
    required this.repository,
    required this.historyRepository,
  });

  // ---------- Lifecycle ----------
  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _handleInitialNavigation();
  }

  @override
  void onClose() {
    _autoSaveTimer?.cancel();
    if (_hasUnsavedChanges && currentSession.value != null) {
      _saveCurrentSession();
    }
    super.onClose();
  }

  void _loadSettings() {}

  void _handleInitialNavigation() {
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      if (args.containsKey('resume') && args['resume'] == true) {
        _resumeActiveSession();
      } else if (args.containsKey('dhikrId')) {
        _startSingleDhikr(
          dhikrId: args['dhikrId'],
          dhikrName: args['dhikrName'] ?? 'Dhikr',
          targetCount: args['recommendedCount'] ?? 33,
        );
      } else {
        _startDefaultOrResume();
      }
    } else {
      _startDefaultOrResume();
    }
  }

  void _startSingleDhikr({
    required String dhikrId,
    required String dhikrName,
    required int targetCount,
  }) {
    final steps = [
      TasbeehStep(id: dhikrId, dhikrName: dhikrName, targetCount: targetCount),
    ];
    final session = TasbeehSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      steps: steps,
      startedAt: DateTime.now(),
      lastUpdatedAt: DateTime.now(),
    );
    _setSession(session);
  }

  void _startPostPrayerTasbeeh() {
    final steps = [
      TasbeehStep(
        id: 'allahuakbar',
        dhikrName: 'Allahu Akbar',
        targetCount: 34,
      ),
      TasbeehStep(id: 'subhanallah', dhikrName: 'SubhanAllah', targetCount: 33),
      TasbeehStep(
        id: 'alhamdulillah',
        dhikrName: 'Alhamdulillah',
        targetCount: 33,
      ),
    ];
    final session = TasbeehSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      steps: steps,
      startedAt: DateTime.now(),
      lastUpdatedAt: DateTime.now(),
    );
    _setSession(session);
  }

  Future<void> _startDefaultOrResume() async {
    final active = await repository.getActiveSession();
    if (active != null) {
      currentSession.value = active;
      _updateUI(active);
      _startAutoSave();
      isCounting.value = true;
    } else {
      _startPostPrayerTasbeeh();
    }
  }

  Future<void> _resumeActiveSession() async {
    final session = await repository.getActiveSession();
    if (session != null) {
      currentSession.value = session;
      _updateUI(session);
      _startAutoSave();
      isCounting.value = true;
    } else {
      _startPostPrayerTasbeeh();
    }
  }

  void _setSession(TasbeehSession session) {
    currentSession.value = session;
    _updateUI(session);
    _startAutoSave();
    isCounting.value = true;
  }

  void _updateUI(TasbeehSession session) {
    count.value = session.currentCount;
    currentDhikrName.value = session.dhikrName;
    targetCount.value = session.targetCount;
    progress.value = session.progress;
    isTargetReached.value = session.isTargetReached;
    allStepsCompleted.value = session.allStepsCompleted;

    if (session.isTargetReached && !showCelebration.value) {
      isCounting.value = false;
      showCelebration.value = true;
    }
  }

  // ---------- Core Actions ----------
  Future<void> incrementCount() async {
    if (currentSession.value == null || !isCounting.value) return;

    if (vibrationEnabled.value) await repository.vibrate();
    if (soundEnabled.value) await repository.playClickSound();

    final session = currentSession.value!;
    final newCount = session.currentCount + 1;
    final reachedTarget = newCount >= session.targetCount;

    final updatedSession = session.copyWith(
      currentCount: newCount,
      lastUpdatedAt: DateTime.now(),
    );

    currentSession.value = updatedSession;
    _updateUI(updatedSession);
    _hasUnsavedChanges = true;

    if (reachedTarget) {
      await _saveCurrentSession();
    }
  }

  Future<void> undoCount() async {
    if (currentSession.value == null) return;
    final session = currentSession.value!;
    if (session.currentCount <= 0) return;

    final updatedSession = session.copyWith(
      currentCount: session.currentCount - 1,
      lastUpdatedAt: DateTime.now(),
    );
    currentSession.value = updatedSession;
    _updateUI(updatedSession);
    _hasUnsavedChanges = true;
    showCelebration.value = false;
    isCounting.value = true;
  }

  Future<void> resetCount() async {
    if (currentSession.value == null) return;
    final session = currentSession.value!;
    final updatedSession = session.copyWith(
      currentCount: 0,
      lastUpdatedAt: DateTime.now(),
    );
    currentSession.value = updatedSession;
    _updateUI(updatedSession);
    _hasUnsavedChanges = true;
    showCelebration.value = false;
    isCounting.value = true;
  }

  // ---------- Public Methods for Celebration Overlay ----------
  void saveAndFinish() {
    if (currentSession.value == null) return;
    final session = currentSession.value!;
    final currentStep = session.currentStep;

    if (currentStep != null && session.isTargetReached) {
      // Save this step to history
      _saveHistoryForStep(session, currentStep);

      // Mark step as completed
      final updatedSteps = List<TasbeehStep>.from(session.steps);
      updatedSteps[session.currentStepIndex] = currentStep.copyWith(
        isCompleted: true,
      );
      final updatedSession = session.copyWith(steps: updatedSteps);
      currentSession.value = updatedSession;
      _saveCurrentSession();

      if (updatedSession.allStepsCompleted) {
        // All steps done – finalise
        _completeSession();
      } else {
        // Advance to next step
        final nextSession = updatedSession.advanceStep();
        currentSession.value = nextSession;
        _updateUI(nextSession);
        _saveCurrentSession();
        showCelebration.value = false;
        isCounting.value = true;
      }
    } else {
      // Single-step or already completed
      _completeSession();
    }
  }

  void discardAndCancel() {
    cancelSession();
  }

  // ---------- Session Completion (no extra history) ----------
  void _completeSession() {
    final session = currentSession.value;
    if (session == null) return;

    if (_isSessionSaved) return;
    _isSessionSaved = true;

    // Mark as completed
    final updatedSession = session.copyWith(
      isCompleted: true,
      lastUpdatedAt: DateTime.now(),
    );
    currentSession.value = updatedSession;
    repository.saveSession(updatedSession);

    // No extra history entry – each step was saved individually

    _autoSaveTimer?.cancel();
    isCounting.value = false;
    showCelebration.value = false;
    Get.offAllNamed('/home');
  }

  // ---------- Cancel (Discard) ----------
  Future<void> cancelSession() async {
    final session = currentSession.value;
    if (session != null) {
      await repository.deleteSession(session.id);
    }
    _autoSaveTimer?.cancel();
    isCounting.value = false;
    currentSession.value = null;
    showCelebration.value = false;
    Get.offAllNamed('/home');
  }

  // ---------- Step History ----------
  void _saveHistoryForStep(TasbeehSession session, TasbeehStep step) {
    if (step.isCompleted) return;
    final historyEntry = HistoryEntry(
      id: '${session.id}_${step.id}_${DateTime.now().millisecondsSinceEpoch}',
      dhikrId: step.id,
      dhikrName: step.dhikrName,
      arabicText: null,
      count: step.targetCount,
      targetCount: step.targetCount,
      isCompleted: true,
      startedAt: session.startedAt,
      completedAt: DateTime.now(),
      durationSeconds: DateTime.now().difference(session.startedAt).inSeconds,
    );
    historyRepository.saveHistoryEntry(historyEntry);
  }

  // ---------- Custom Dhikr ----------
  void addCustomDhikr(String name, int target) {
    final session = currentSession.value;
    if (session == null) return;
    final newStep = TasbeehStep(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      dhikrName: name,
      targetCount: target,
    );
    final updatedSteps = List<TasbeehStep>.from(session.steps)..add(newStep);
    final updatedSession = session.copyWith(steps: updatedSteps);
    currentSession.value = updatedSession;
    _updateUI(updatedSession);
    _hasUnsavedChanges = true;
    _saveCurrentSession();
  }

  // ---------- Persistence ----------
  Future<void> _saveCurrentSession() async {
    final session = currentSession.value;
    if (session == null) return;
    await repository.saveSession(session);
    _hasUnsavedChanges = false;
  }

  void _startAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_hasUnsavedChanges && currentSession.value != null) {
        _saveCurrentSession();
      }
    });
  }

  // ---------- Settings Toggles ----------
  void toggleVibration(bool value) => vibrationEnabled.value = value;
  void toggleSound(bool value) => soundEnabled.value = value;
}
