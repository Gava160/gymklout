import 'package:gymklout/models/gym_model.dart';
import 'package:gymklout/models/profile_model.dart';

enum MembershipRole { member, trainer, admin }
enum MembershipStatus { active, inactive, pending }

class MembershipModel {
  final String id;
  final String userId;
  final String gymId;
  final MembershipRole role;
  final MembershipStatus status;
  final DateTime joinedAt;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Joined data
  final ProfileModel? profile;
  final GymModel? gym;

  const MembershipModel({
    required this.id,
    required this.userId,
    required this.gymId,
    required this.role,
    required this.status,
    required this.joinedAt,
    this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
    this.profile,
    this.gym,
  });

  bool get isActive => status == MembershipStatus.active;
  bool get isExpired =>
      expiresAt != null && expiresAt!.isBefore(DateTime.now());
  bool get isAdmin => role == MembershipRole.admin;
  bool get isTrainer => role == MembershipRole.trainer;

  factory MembershipModel.fromJson(Map<String, dynamic> json) {
    return MembershipModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      gymId: json['gym_id'] as String,
      role: MembershipRole.values.firstWhere(
        (e) => e.name == (json['role'] as String? ?? 'member'),
        orElse: () => MembershipRole.member,
      ),
      status: MembershipStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String? ?? 'active'),
        orElse: () => MembershipStatus.active,
      ),
      joinedAt: DateTime.parse(json['joined_at'] as String),
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      profile: json['profiles'] != null
          ? ProfileModel.fromJson(json['profiles'] as Map<String, dynamic>)
          : null,
      gym: json['gyms'] != null
          ? GymModel.fromJson(json['gyms'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'gym_id': gymId,
      'role': role.name,
      'status': status.name,
      'joined_at': joinedAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}