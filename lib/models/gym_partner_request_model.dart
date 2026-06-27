import 'package:gymklout/models/gym_model.dart';
import 'package:gymklout/models/profile_model.dart';

enum PartnerRequestStatus { pending, accepted, declined }

class GymPartnerRequestModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String gymId;
  final PartnerRequestStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Joined data
  final ProfileModel? sender;
  final ProfileModel? receiver;
  final GymModel? gym;

  const GymPartnerRequestModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.gymId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.sender,
    this.receiver,
    this.gym,
  });

  bool get isPending => status == PartnerRequestStatus.pending;
  bool get isAccepted => status == PartnerRequestStatus.accepted;
  bool get isDeclined => status == PartnerRequestStatus.declined;

  factory GymPartnerRequestModel.fromJson(Map<String, dynamic> json) {
    return GymPartnerRequestModel(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      gymId: json['gym_id'] as String,
      status: PartnerRequestStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String? ?? 'pending'),
        orElse: () => PartnerRequestStatus.pending,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      sender: json['sender'] != null
          ? ProfileModel.fromJson(json['sender'] as Map<String, dynamic>)
          : null,
      receiver: json['receiver'] != null
          ? ProfileModel.fromJson(json['receiver'] as Map<String, dynamic>)
          : null,
      gym: json['gyms'] != null
          ? GymModel.fromJson(json['gyms'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'gym_id': gymId,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}