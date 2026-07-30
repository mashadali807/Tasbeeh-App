import 'dart:async';
import 'package:get/get.dart';
import 'package:tasbeeh/features/history/repositories/history_repo.dart';
import '../../history/models/history_entry.dart';
import '../models/tasbeeh_session.dart';
import '../models/tasbeeh_step.dart';
import '../repositories/tasbeeh_repository.dart';

/// Controller for the Smart Tasbeeh Counter.
/// Manages a multi‑step counting session (e.g., SubhanAllah → Alhamdulillah → Allahu Akbar).
/// Handles persistence, haptics, sound, and auto‑advance.
class TasbeehController extends GetxController {
  final TasbeehRepository repository;
  final HistoryRepository historyRepository; // ✅ injected

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

  // Settings (loaded from local storage later)
  final RxBool vibrationEnabled = true.obs;
  final RxBool soundEnabled = true.obs;

  // ---------- Internal State ----------
  Timer? _autoSaveTimer;
  bool _hasUnsavedChanges = false;

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

  // ---------- Initialisation ----------
  void _loadSettings() {
    // TODO: Load from SettingsService when available
  }

  /// Decide what to do when the screen opens.
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

  /// Start a single‑step session (when coming from the library).
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

  /// Start the default post‑prayer tasbeeh: SubhanAllah (33) → Alhamdulillah (33) → Allahu Akbar (34).
  void _startPostPrayerTasbeeh() {
    final steps = [
      TasbeehStep(id: 'subhanallah', dhikrName: 'SubhanAllah', targetCount: 33),
      TasbeehStep(
        id: 'alhamdulillah',
        dhikrName: 'Alhamdulillah',
        targetCount: 33,
      ),
      TasbeehStep(
        id: 'allahuakbar',
        dhikrName: 'Allahu Akbar',
        targetCount: 34,
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

  /// Resume the most recent active session, or start the default if none exists.
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

  /// Explicitly resume an active session (used when the route passes `resume: true`).
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

  /// Set the session and update UI.
  void _setSession(TasbeehSession session) {
    currentSession.value = session;
    _updateUI(session);
    _startAutoSave();
    isCounting.value = true;
  }

  // ---------- UI Update ----------
  void _updateUI(TasbeehSession session) {
    count.value = session.currentCount;
    currentDhikrName.value = session.dhikrName;
    targetCount.value = session.targetCount;
    progress.value = session.progress;
    isTargetReached.value = session.isTargetReached;
    allStepsCompleted.value = session.allStepsCompleted;

    if (session.isTargetReached && !showCelebration.value) {
      _handleStepCompletion();
    }
  }

  // ---------- Core Actions ----------
  /// Increment the count.
  Future<void> incrementCount() async {
    if (currentSession.value == null) return;

    // Feedback
    if (vibrationEnabled.value) {
      await repository.vibrate();
    }
    if (soundEnabled.value) {
      await repository.playClickSound();
    }

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

    // Save immediately if target reached (auto‑save will also kick in)
    if (reachedTarget) {
      await _saveCurrentSession();
    }
  }

  /// Undo the last increment.
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
  }

  /// Reset the count for the current step.
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
  }

  /// Cancel the entire session – discard progress and return to Home.
  Future<void> cancelSession() async {
    final session = currentSession.value;
    if (session != null) {
      // Delete the session completely (don't save)
      await repository.deleteSession(session.id);
    }
    _autoSaveTimer?.cancel();
    isCounting.value = false;
    currentSession.value = null; // clear local reference
    Get.offAllNamed('/home');
  }

  /// Add a custom Dhikr step to the current session.
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

  // ---------- Step Advancement ----------
  void _handleStepCompletion() {
    _triggerCelebration();
    // Auto‑advance after celebration
    Future.delayed(const Duration(seconds: 3), () {
      if (currentSession.value != null) {
        _advanceToNextStep();
      }
    });
  }

  void _advanceToNextStep() {
    final session = currentSession.value;
    if (session == null) return;

    // Get the step that was just completed (the current step before advancing)
    final completedStep = session.currentStep;
    if (completedStep != null) {
      // Save a history entry for this step
      _saveHistoryForStep(session, completedStep);
    }

    // Advance to the next step
    final updatedSession = session.advanceStep();
    currentSession.value = updatedSession;
    _updateUI(updatedSession);
    _hasUnsavedChanges = true;
    _saveCurrentSession();

    if (updatedSession.allStepsCompleted) {
      // Final celebration if all steps are done
      _triggerCelebration();
    }
  }

  // ---------- History ----------
  void _saveHistoryForStep(TasbeehSession session, TasbeehStep step) {
    // Save history entry for this completed step
    final historyEntry = HistoryEntry(
      id: '${session.id}_${step.id}_${DateTime.now().millisecondsSinceEpoch}',
      dhikrId: step.id,
      dhikrName: step.dhikrName,
      arabicText: null, // could be fetched later
      count: step.targetCount, // assume user completed full target
      targetCount: step.targetCount,
      isCompleted: true,
      startedAt: session.startedAt,
      completedAt: DateTime.now(),
      durationSeconds: DateTime.now().difference(session.startedAt).inSeconds,
    );
    historyRepository.saveHistoryEntry(historyEntry);
  }

  // ---------- Celebration ----------
  void _triggerCelebration() {
    showCelebration.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      showCelebration.value = false;
    });
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
  void toggleVibration(bool value) {
    vibrationEnabled.value = value;
    // TODO: persist to SettingsService
  }

  void toggleSound(bool value) {
    soundEnabled.value = value;
    // TODO: persist to SettingsService
  }
}
