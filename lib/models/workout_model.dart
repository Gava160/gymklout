import 'package:gymklout/models/gym_model.dart';
import 'package:gymklout/models/workout_plan_model.dart';
import 'package:gymklout/models/workout_set_model.dart';

class WorkoutModel {
  final String id;
  final String userId;
  final String? gymId;
  final String? planId;
  final String? title;
  final String? notes;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int? durationSec;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Joined data
  final List<WorkoutSetModel>? sets;
  final GymModel? gym;
  final WorkoutPlanModel? plan;

  const WorkoutModel({
    required this.id,
    required this.userId,
    this.gymId,
    this.planId,
    this.title,
    this.notes,
    required this.startedAt,
    this.endedAt,
    this.durationSec,
    required this.createdAt,
    required this.updatedAt,
    this.sets,
    this.gym,
    this.plan,
  });

  Duration? get duration =>
      durationSec != null ? Duration(seconds: durationSec!) : null;

  int get totalSets => sets?.length ?? 0;

  double get totalVolumeKg => sets?.fold(0.0, (sum, s) {
        final reps = s.reps ?? 0;
        final weight = s.weightKg ?? 0.0;
        return (sum ?? 0.0) + (reps * weight);
      }) ?? 0.0;

  bool get isActive => endedAt == null;

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      gymId: json['gym_id'] as String?,
      planId: json['plan_id'] as String?,
      title: json['title'] as String?,
      notes: json['notes'] as String?,
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: json['ended_at'] != null
          ? DateTime.parse(json['ended_at'] as String)
          : null,
      durationSec: json['duration_sec'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      sets: json['workout_sets'] != null
          ? (json['workout_sets'] as List)
              .map((s) => WorkoutSetModel.fromJson(s as Map<String, dynamic>))
              .toList()
          : null,
      gym: json['gyms'] != null
          ? GymModel.fromJson(json['gyms'] as Map<String, dynamic>)
          : null,
      plan: json['workout_plans'] != null
          ? WorkoutPlanModel.fromJson(
              json['workout_plans'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'gym_id': gymId,
      'plan_id': planId,
      'title': title,
      'notes': notes,
      'started_at': startedAt.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'duration_sec': durationSec,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  WorkoutModel copyWith({
    String? title,
    String? notes,
    DateTime? endedAt,
    int? durationSec,
    List<WorkoutSetModel>? sets,
  }) {
    return WorkoutModel(
      id: id,
      userId: userId,
      gymId: gymId,
      planId: planId,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      startedAt: startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationSec: durationSec ?? this.durationSec,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      sets: sets ?? this.sets,
      gym: gym,
      plan: plan,
    );
  }
}