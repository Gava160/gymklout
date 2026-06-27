class ProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final String? phone;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final double? weightKg;
  final double? heightCm;
  final String? goal;
  final String? bio;
  final bool completedProfileRegistration;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    this.phone,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.city,
    this.state,
    this.country,
    this.weightKg,
    this.heightCm,
    this.goal,
    this.bio,
    required this.completedProfileRegistration,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isProfileComplete => completedProfileRegistration;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      phone: json['phone'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      weightKg: json['weight_kg'] != null
          ? (json['weight_kg'] as num).toDouble()
          : null,
      heightCm: json['height_cm'] != null
          ? (json['height_cm'] as num).toDouble()
          : null,
      goal: json['goal'] as String?,
      bio: json['bio'] as String?,
      completedProfileRegistration:
          json['completed_profile_registration'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'avatar_url': avatarUrl,
      'phone': phone,
      'gender': gender,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'weight_kg': weightKg,
      'height_cm': heightCm,
      'goal': goal,
      'bio': bio,
      'completed_profile_registration': completedProfileRegistration,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ProfileModel copyWith({
    String? fullName,
    String? avatarUrl,
    String? phone,
    String? gender,
    DateTime? dateOfBirth,
    String? address,
    String? city,
    String? state,
    String? country,
    double? weightKg,
    double? heightCm,
    String? goal,
    String? bio,
    bool? completedProfileRegistration,
  }) {
    return ProfileModel(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      goal: goal ?? this.goal,
      bio: bio ?? this.bio,
      completedProfileRegistration:
          completedProfileRegistration ?? this.completedProfileRegistration,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}