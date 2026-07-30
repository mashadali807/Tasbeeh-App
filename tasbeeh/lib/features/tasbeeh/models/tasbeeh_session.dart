import 'tasbeeh_step.dart';

class TasbeehSession {
  final String id;
  final List<TasbeehStep> steps;
  final int currentStepIndex;
  final int currentCount;
  final DateTime startedAt;
  final DateTime? lastUpdatedAt;
  final bool isCompleted;

  TasbeehSession({
    required this.id,
    required this.steps,
    this.currentStepIndex = 0,
    this.currentCount = 0,
    required this.startedAt,
    this.lastUpdatedAt,
    this.isCompleted = false,
  });

  // Get the current step
  TasbeehStep? get currentStep {
    if (currentStepIndex >= steps.length) return null;
    return steps[currentStepIndex];
  }

  // Check if all steps are completed
  bool get allStepsCompleted => steps.every((step) => step.isCompleted);

  // Get current target count
  int get targetCount => currentStep?.targetCount ?? 0;

  // Get current dhikr name
  String get dhikrName => currentStep?.dhikrName ?? '';

  // Progress of current step
  double get progress {
    final target = targetCount;
    if (target == 0) return 0.0;
    return currentCount / target;
  }

  bool get isTargetReached => currentCount >= targetCount;

  factory TasbeehSession.fromJson(Map<String, dynamic> json) {
    final stepsList = (json['steps'] as List)
        .map((e) => TasbeehStep.fromJson(e))
        .toList();
    return TasbeehSession(
      id: json['id'],
      steps: stepsList,
      currentStepIndex: json['currentStepIndex'] ?? 0,
      currentCount: json['currentCount'] ?? 0,
      startedAt: DateTime.parse(json['startedAt']),
      lastUpdatedAt: json['lastUpdatedAt'] != null
          ? DateTime.parse(json['lastUpdatedAt'])
          : null,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'steps': steps.map((e) => e.toJson()).toList(),
    'currentStepIndex': currentStepIndex,
    'currentCount': currentCount,
    'startedAt': startedAt.toIso8601String(),
    'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
    'isCompleted': isCompleted,
  };

  TasbeehSession copyWith({
    int? currentStepIndex,
    int? currentCount,
    DateTime? lastUpdatedAt,
    bool? isCompleted,
    List<TasbeehStep>? steps,
  }) {
    return TasbeehSession(
      id: id,
      steps: steps ?? this.steps,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      currentCount: currentCount ?? this.currentCount,
      startedAt: startedAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // Move to next step
  TasbeehSession advanceStep() {
    if (currentStepIndex >= steps.length - 1) {
      // All steps completed
      return copyWith(
        isCompleted: true,
        lastUpdatedAt: DateTime.now(),
      );
    }
    // Mark current step as completed and move to next
    final updatedSteps = List<TasbeehStep>.from(steps);
    updatedSteps[currentStepIndex] = updatedSteps[currentStepIndex]
        .copyWith(isCompleted: true);
    return TasbeehSession(
      id: id,
      steps: updatedSteps,
      currentStepIndex: currentStepIndex + 1,
      currentCount: 0, // Reset count for next step
      startedAt: startedAt,
      lastUpdatedAt: DateTime.now(),
      isCompleted: false,
    );
  }
}