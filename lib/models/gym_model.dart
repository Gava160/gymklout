class GymModel {
  final String id;
  final String name;
  final String? description;
  final String? email;
  final String? phone;
  final String? website;
  final String? logoUrl;
  final String? coverUrl;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final double latitude;
  final double longitude;
  final List<String> amenities;
  final Map<String, dynamic>? openingHours;
  final bool isActive;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Computed at runtime — not from DB
  final double? distanceKm;

  const GymModel({
    required this.id,
    required this.name,
    this.description,
    this.email,
    this.phone,
    this.website,
    this.logoUrl,
    this.coverUrl,
    this.address,
    this.city,
    this.state,
    this.country,
    required this.latitude,
    required this.longitude,
    required this.amenities,
    this.openingHours,
    required this.isActive,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
    this.distanceKm,
  });

  // Whether this gym is the closest one in the list
  bool get isClosest => distanceKm != null;

  String get distanceLabel {
    if (distanceKm == null) return '';
    if (distanceKm! < 1) return '${(distanceKm! * 1000).toStringAsFixed(0)}m away';
    return '${distanceKm!.toStringAsFixed(1)}km away';
  }

  factory GymModel.fromJson(Map<String, dynamic> json) {
    return GymModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      logoUrl: json['logo_url'] as String?,
      coverUrl: json['cover_url'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      amenities: json['amenities'] != null
          ? List<String>.from(json['amenities'] as List)
          : [],
      openingHours: json['opening_hours'] as Map<String, dynamic>?,
      isActive: json['is_active'] as bool? ?? true,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      distanceKm: json['distance_km'] != null
          ? (json['distance_km'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'email': email,
      'phone': phone,
      'website': website,
      'logo_url': logoUrl,
      'cover_url': coverUrl,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'amenities': amenities,
      'opening_hours': openingHours,
      'is_active': isActive,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  GymModel copyWith({
    double? distanceKm,
    String? logoUrl,
    String? coverUrl,
  }) {
    return GymModel(
      id: id,
      name: name,
      description: description,
      email: email,
      phone: phone,
      website: website,
      logoUrl: logoUrl ?? this.logoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      address: address,
      city: city,
      state: state,
      country: country,
      latitude: latitude,
      longitude: longitude,
      amenities: amenities,
      openingHours: openingHours,
      isActive: isActive,
      isVerified: isVerified,
      createdAt: createdAt,
      updatedAt: updatedAt,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }
}