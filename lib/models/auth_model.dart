import 'package:gymklout/models/profile_model.dart';

class AuthUserModel {
  final String id;
  final String email;
  final ProfileModel? profile;

  const AuthUserModel({
    required this.id,
    required this.email,
    this.profile,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      profile: json['profile'] != null
          ? ProfileModel.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
    );
  }
}

class LoginResponseModel {
  final String accessToken;
  final String refreshToken;
  final int? expiresAt;
  final AuthUserModel user;

  const LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    this.expiresAt,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: json['expiresAt'] as int?,
      user: AuthUserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class RegisterResponseModel {
  final String message;
  final String userId;

  const RegisterResponseModel({required this.message, required this.userId});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      message: json['message'] as String,
      userId: json['userId'] as String,
    );
  }
}