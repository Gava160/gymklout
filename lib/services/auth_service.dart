import 'package:gymklout/models/auth_model.dart';
import 'package:gymklout/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  final ApiService _api;

  AuthService(this._api);

  // ─── Login ──────────────────────────────────────────────────────────────────
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post('/auth/login', {
      'email': email,
      'password': password,
    });

    final model = LoginResponseModel.fromJson(response);

    await ApiService.saveTokens(
      accessToken: model.accessToken,
      refreshToken: model.refreshToken,
    );

    return model;
  }

  // ─── Register ───────────────────────────────────────────────────────────────
  Future<RegisterResponseModel> register({
    required String email,
    required String password,
    required String fullName,
    String? avatarUrl,
  }) async {
    final body = <String, dynamic>{
      'email': email,
      'password': password,
      'fullName': fullName,
    };

    if (avatarUrl != null) body['avatarUrl'] = avatarUrl;

    final response = await _api.post('/auth/register', body);
    return RegisterResponseModel.fromJson(response);
  }

  // ─── Complete Profile ─────────────────────────────────────────────────────────
Future<void> completeProfile({
  String? gender,
  int? age,
  double? weightKg,
  double? heightCm,
  String? goal,
  String? activityLevel,
  String? fitnessLevel,
  double? targetWeightKg,
  int? workoutFrequency,
  bool? completedProfileRegistration,
}) async {
  final body = <String, dynamic>{};
  if (gender != null)                       body['gender']                       = gender;
  if (age != null)                          body['age']                          = age;
  if (weightKg != null)                     body['weightKg']                     = weightKg;
  if (heightCm != null)                     body['heightCm']                     = heightCm;
  if (goal != null)                         body['goal']                         = goal;
  if (activityLevel != null)                body['activityLevel']                = activityLevel;
  if (fitnessLevel != null)                 body['fitnessLevel']                 = fitnessLevel;
  if (targetWeightKg != null)               body['targetWeightKg']               = targetWeightKg;
  if (workoutFrequency != null)             body['workoutFrequency']             = workoutFrequency;
  if (completedProfileRegistration != null) body['completedProfileRegistration'] = completedProfileRegistration;

  await _api.post('/profiles/complete', body, requiresAuth: true);
}

  // ─── Verify OTP ──────────────────────────────────────────────────────────────
  Future<VerifyOtpResponseModel> verifyOtp({
    required String email,
    required String token,
  }) async {
    final response = await _api.post('/auth/verify-otp', {
      'email': email,
      'token': token,
    });
    final model = VerifyOtpResponseModel.fromJson(response);
    await ApiService.saveTokens(
      accessToken: model.accessToken,
      refreshToken: model.refreshToken,
    );
    return model;
  }

  // ─── Resend Verification ─────────────────────────────────────────────────────
  Future<void> resendVerification({required String email}) async {
    await _api.post('/auth/resend-verification', {'email': email});
  }

  // ─── Logout ─────────────────────────────────────────────────────────────────
  Future<void> logout(String accessToken) async {
    try {
      await _api.post('/auth/logout', {}, requiresAuth: true);
    } finally {
      await ApiService.clearTokens();
    }
  }

  // ─── Forgot Password ─────────────────────────────────────────────────────────
  Future<String> forgotPassword(String email) async {
    final response = await _api.post('/auth/forgot-password', {'email': email});
    return response['message'] as String;
  }
  // ─── Restore Session ─────────────────────────────────────────────────────────
Future<LoginResponseModel> restoreSession({
  required String accessToken,
  required String refreshToken,
}) async {
  return _api.restoreSession(
    accessToken: accessToken,
    refreshToken: refreshToken,
  );
}




}

// ─── Provider ────────────────────────────────────────────────────────────────
final authServiceProvider = Provider<AuthService>((ref) {
  final api = ref.watch(apiServiceProvider);
  return AuthService(api);
});