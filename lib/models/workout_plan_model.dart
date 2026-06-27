class WorkoutPlanModel {
  final String id;
  final String? gymId;
  final String? createdBy;
  final String title;
  final String? description;
  final String? goal;
  final String? level;
  final int? durationWeeks;
  final bool isPublic;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WorkoutPlanModel({
    required this.id,
    this.gymId,
    this.createdBy,
    required this.title,
    this.description,
    this.goal,
    this.level,
    required this.isPublic,
    this.durationWeeks,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkoutPlanModel.fromJson(Map<String, dynamic> json) {
    return WorkoutPlanModel(
      id: json['id'] as String,
      gymId: json['gym_id'] as String?,
      createdBy: json['created_by'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      goal: json['goal'] as String?,
      level: json['level'] as String?,
      durationWeeks: json['duration_weeks'] as int?,
      isPublic: json['is_public'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gym_id': gymId,
      'created_by': createdBy,
      'title': title,
      'description': description,
      'goal': goal,
      'level': level,
      'duration_weeks': durationWeeks,
      'is_public': isPublic,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  WorkoutPlanModel copyWith({
    String? title,
    String? description,
    String? goal,
    String? level,
    int? durationWeeks,
    bool? isPublic,
  }) {
    return WorkoutPlanModel(
      id: id,
      gymId: gymId,
      createdBy: createdBy,
      title: title ?? this.title,
      description: description ?? this.description,
      goal: goal ?? this.goal,
      level: level ?? this.level,
      durationWeeks: durationWeeks ?? this.durationWeeks,
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}