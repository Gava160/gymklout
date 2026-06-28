import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/models/auth_model.dart';
import 'package:gymklout/models/profile_model.dart';
import 'package:gymklout/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Auth State ──────────────────────────────────────────────────────────────
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthAuthenticated extends AuthState {
  final LoginResponseModel data;
  const AuthAuthenticated(this.data);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

// ─── Auth Notifier ───────────────────────────────────────────────────────────
class AuthNotifier extends AsyncNotifier<AuthState> {
  late AuthService _authService;

  @override
  Future<AuthState> build() async {
    _authService = ref.watch(authServiceProvider);
    return _checkExistingSession();
  }

  // Check if a token already exists on app launch
  Future<AuthState> _checkExistingSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token != null && token.isNotEmpty) {
      // Token exists but we don't have the full model in memory.
      // The splash screen / app router will call getMe if needed.
      // For now, treat as unauthenticated so login is required.
      // You can expand this later to restore session silently.
      return const AuthUnauthenticated();
    }
    return const AuthUnauthenticated();
  }

  // ─── Login ──────────────────────────────────────────────────────────────────
  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result = await _authService.login(email: email, password: password);
      return AuthAuthenticated(result);
    });
  }

  // ─── Register ───────────────────────────────────────────────────────────────
  Future<RegisterResponseModel> register({
    required String email,
    required String password,
    required String fullName,
    String? avatarUrl,
  }) async {
    // Registration doesn't change auth state — user still needs to verify email
    return _authService.register(
      email: email,
      password: password,
      fullName: fullName,
      avatarUrl: avatarUrl,
    );
  }

  // ─── Logout ─────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    await _authService.logout(token);
    state = const AsyncData(AuthUnauthenticated());
  }

  // ─── Forgot Password ─────────────────────────────────────────────────────────
  Future<String> forgotPassword(String email) async {
    return _authService.forgotPassword(email);
  }

  // ─── Verify OTP ──────────────────────────────────────────────────────────────
Future<VerifyOtpResponseModel> verifyOtp({
  required String email,
  required String token,
}) async {
  return _authService.verifyOtp(email: email, token: token);
}

// ─── Resend Verification ─────────────────────────────────────────────────────
Future<void> resendVerification({required String email}) async {
  await _authService.resendVerification(email: email);
}


}

// ─── Provider ────────────────────────────────────────────────────────────────
final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

 final currentProfileProvider = Provider<ProfileModel?>((ref) {
      final state = ref.watch(authProvider).asData?.value;
      if (state is AuthAuthenticated) return state.data.user.profile;
      return null;
    });