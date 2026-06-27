enum MuscleGroup {
  chest, back, shoulders, arms,
  legs, glutes, core, cardio, fullBody
}

enum Equipment {
  barbell, dumbbell, machine, cable,
  bodyweight, resistanceBand, other
}

enum Difficulty { beginner, intermediate, advanced }

class ExerciseModel {
  final String id;
  final String? createdBy;
  final String name;
  final String? description;
  final MuscleGroup? muscleGroup;
  final Equipment? equipment;
  final Difficulty? difficulty;
  final String? videoUrl;
  final String? thumbnailUrl;
  final bool isPublic;
  final DateTime createdAt;

  const ExerciseModel({
    required this.id,
    this.createdBy,
    required this.name,
    this.description,
    this.muscleGroup,
    this.equipment,
    this.difficulty,
    this.videoUrl,
    this.thumbnailUrl,
    required this.isPublic,
    required this.createdAt,
  });

  // Maps snake_case DB values to enum
  static MuscleGroup? _parseMuscleGroup(String? value) {
    const map = {
      'chest': MuscleGroup.chest,
      'back': MuscleGroup.back,
      'shoulders': MuscleGroup.shoulders,
      'arms': MuscleGroup.arms,
      'legs': MuscleGroup.legs,
      'glutes': MuscleGroup.glutes,
      'core': MuscleGroup.core,
      'cardio': MuscleGroup.cardio,
      'full_body': MuscleGroup.fullBody,
    };
    return map[value];
  }

  static Equipment? _parseEquipment(String? value) {
    const map = {
      'barbell': Equipment.barbell,
      'dumbbell': Equipment.dumbbell,
      'machine': Equipment.machine,
      'cable': Equipment.cable,
      'bodyweight': Equipment.bodyweight,
      'resistance_band': Equipment.resistanceBand,
      'other': Equipment.other,
    };
    return map[value];
  }

  static String? _muscleGroupToString(MuscleGroup? mg) {
    if (mg == null) return null;
    if (mg == MuscleGroup.fullBody) return 'full_body';
    return mg.name;
  }

  static String? _equipmentToString(Equipment? eq) {
    if (eq == null) return null;
    if (eq == Equipment.resistanceBand) return 'resistance_band';
    return eq.name;
  }

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] as String,
      createdBy: json['created_by'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      muscleGroup: _parseMuscleGroup(json['muscle_group'] as String?),
      equipment: _parseEquipment(json['equipment'] as String?),
      difficulty: json['difficulty'] != null
          ? Difficulty.values.firstWhere(
              (e) => e.name == json['difficulty'],
              orElse: () => Difficulty.beginner,
            )
          : null,
      videoUrl: json['video_url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      isPublic: json['is_public'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_by': createdBy,
      'name': name,
      'description': description,
      'muscle_group': _muscleGroupToString(muscleGroup),
      'equipment': _equipmentToString(equipment),
      'difficulty': difficulty?.name,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'is_public': isPublic,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ExerciseModel copyWith({
    String? name,
    String? description,
    MuscleGroup? muscleGroup,
    Equipment? equipment,
    Difficulty? difficulty,
    String? videoUrl,
    String? thumbnailUrl,
    bool? isPublic,
  }) {
    return ExerciseModel(
      id: id,
      createdBy: createdBy,
      name: name ?? this.name,
      description: description ?? this.description,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      equipment: equipment ?? this.equipment,
      difficulty: difficulty ?? this.difficulty,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt,
    );
  }
}