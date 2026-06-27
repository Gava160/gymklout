import 'package:gymklout/models/exercise_model.dart';

class WorkoutSetModel {
  final String id;
  final String workoutId;
  final String exerciseId;
  final int setNumber;
  final int? reps;
  final double? weightKg;
  final int? durationSec;
  final int? restSec;
  final String? notes;
  final DateTime createdAt;

  // Joined data
  final ExerciseModel? exercise;

  const WorkoutSetModel({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.setNumber,
    this.reps,
    this.weightKg,
    this.durationSec,
    this.restSec,
    this.notes,
    required this.createdAt,
    this.exercise,
  });

  factory WorkoutSetModel.fromJson(Map<String, dynamic> json) {
    return WorkoutSetModel(
      id: json['id'] as String,
      workoutId: json['workout_id'] as String,
      exerciseId: json['exercise_id'] as String,
      setNumber: json['set_number'] as int,
      reps: json['reps'] as int?,
      weightKg: json['weight_kg'] != null
          ? (json['weight_kg'] as num).toDouble()
          : null,
      durationSec: json['duration_sec'] as int?,
      restSec: json['rest_sec'] as int?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      exercise: json['exercises'] != null
          ? ExerciseModel.fromJson(json['exercises'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workout_id': workoutId,
      'exercise_id': exerciseId,
      'set_number': setNumber,
      'reps': reps,
      'weight_kg': weightKg,
      'duration_sec': durationSec,
      'rest_sec': restSec,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  WorkoutSetModel copyWith({
    int? reps,
    double? weightKg,
    int? durationSec,
    int? restSec,
    String? notes,
  }) {
    return WorkoutSetModel(
      id: id,
      workoutId: workoutId,
      exerciseId: exerciseId,
      setNumber: setNumber,
      reps: reps ?? this.reps,
      weightKg: weightKg ?? this.weightKg,
      durationSec: durationSec ?? this.durationSec,
      restSec: restSec ?? this.restSec,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      exercise: exercise,
    );
  }
}