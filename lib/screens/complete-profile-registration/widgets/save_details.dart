// ------
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/custom_notification.dart';
import 'package:gymklout/providers/auth_provider.dart';
import 'package:gymklout/screens/bottom-navigation/bottom_nav_bar.dart';

Future<void> saveProfile({
  required WidgetRef ref,
  required BuildContext context,
  String? selectedGender,
  int? selectedAge,
  double? selectedWeight,
  double? selectedHeight,
  String? selectedGoal,
  String? selectedActivityLevel,
  String? selectedFitnessLevel,
  double? selectedTargetWeight,
  int? selectedWorkoutFrequency,
  required VoidCallback nextScreen,
  required VoidCallback onDone,
}) async {
  final isCompleted =
      selectedGender != null &&
      selectedAge != null &&
      selectedWeight != null &&
      selectedHeight != null &&
      selectedGoal != null &&
      selectedActivityLevel != null &&
      selectedFitnessLevel != null &&
      selectedTargetWeight != null &&
      selectedWorkoutFrequency != null;
  try {
    await ref
        .read(authProvider.notifier)
        .completeProfile(
          gender: selectedGender,
          age: selectedAge,
          weightKg: selectedWeight,
          heightCm: selectedHeight,
          goal: selectedGoal,
          activityLevel: selectedActivityLevel,
          fitnessLevel: selectedFitnessLevel,
          targetWeightKg: selectedTargetWeight,
          workoutFrequency: selectedWorkoutFrequency,
          completedProfileRegistration: isCompleted,
        );

    if (!context.mounted) return;
    if (isCompleted) {
      onDone();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const BottomNavBarController()),
        (route) => false,
      );
    } else {
      onDone();
      nextScreen();
    }
  } catch (e) {
    onDone();
    print(e);
    if (!context.mounted) return;
    HapticFeedback.heavyImpact();
    showTopAlert(context, message: e.toString(), type: AlertType.error);
  }
}

String goalToBackendValue(String goal) {
  const map = {
    'Lose Weight': 'lose_weight',
    'Build Muscle': 'build_muscle',
    'Improve Endurance': 'endurance',
    'Stay Active': 'maintain',
    'Increase Flexibility': 'flexibility',
    'Reduce Stress': 'reduce_stress',
    'Eat Healthier': 'eat_healthier',
  };
  return map[goal] ?? 'maintain';
}

String fitnessLevelToBackendValue(String value) {
  const map = {
    'Rookie': 'beginner',
    'Beginner': 'beginner',
    'Intermediate': 'intermediate',
    'Advance': 'advanced',
    'True Beast': 'advanced',
  };
  return map[value] ?? 'beginner';
}
