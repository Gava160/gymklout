import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      final bool canAuthenticate =
          await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) return false;

      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Authenticate to continue',
        biometricOnly: true, // 👈 this replaces AuthenticationOptions
      );

      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }
}