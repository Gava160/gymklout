import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isSubmitting = false;
  bool buttonIsEnabled = false;

  int _loginAttempts = 0;
  bool _isLockedOut = false;
  DateTime? _lockoutEnd;
  static const int _maxAttempts = 2;
  static const int _lockoutMinutes = 5;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    emailController.addListener(_validate);
    passwordController.addListener(_validate);

    super.initState();
  }

  void _validate() {
    final email = emailController.text.trim();
    final enable =
        email.isNotEmpty &&
        email.contains('@') &&
        email.contains('.') &&
        passwordController.text.trim().isNotEmpty;

    if (enable != buttonIsEnabled) {
      setState(() => buttonIsEnabled = enable);
    }
  }


  // // On sign-out
  // Future<void> unlinkOneSignal() async {
  //   await OneSignal.logout();
  // }

  // ───────────────────────────────────────────────────────────────────────────────
  // Future<void> loginAccount() async {
  //   // Check lockout
  //   if (_isLockedOut && _lockoutEnd != null) {
  //     final remaining = _lockoutEnd!.difference(DateTime.now()).inMinutes + 1;
  //     showTopAlert(
  //       context,
  //       message:
  //           "Too many attempts. Try again in $remaining minute${remaining == 1 ? '' : 's'}.",
  //       color: AppDefaults.errorColor,
  //       icon: Iconsax.danger,
  //     );
  //     return;
  //   }

  //   setState(() => isSubmitting = true);

  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: emailController.text.trim(),
  //       password: passwordController.text.trim(),
  //     );

  //     // Reset attempts on success
  //     setState(() {
  //       _loginAttempts = 0;
  //       _isLockedOut = false;
  //       _lockoutEnd = null;
  //     });

  //     final user = FirebaseAuth.instance.currentUser;
  //     await linkOneSignalToUser(user?.uid ?? "");
  //     await InAppMessageService.onUserLoggedIn();

  //     if (!mounted) return;
  //     Navigator.pushNamedAndRemoveUntil(
  //       context,
  //       AppRoutes.home,
  //       (route) => false,
  //     );

  //     showTopAlert(
  //       context,
  //       message: "Login successful",
  //       color: AppDefaults.successColor,
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     HapticFeedback.lightImpact();

  //     // Increment attempts for credential errors
  //     final isCredentialError = [
  //       'wrong-password',
  //       'user-not-found',
  //       'invalid-credential',
  //       'invalid-email',
  //     ].contains(e.code);

  //     if (isCredentialError) {
  //       _loginAttempts++;
  //       if (_loginAttempts >= _maxAttempts) {
  //         _lockoutEnd = DateTime.now().add(Duration(minutes: _lockoutMinutes));
  //         setState(() {
  //           _isLockedOut = true;
  //           isSubmitting = false;
  //         });

  //         // Auto-unlock after lockout period
  //         Future.delayed(Duration(minutes: _lockoutMinutes), () {
  //           if (mounted) {
  //             setState(() {
  //               _isLockedOut = false;
  //               _loginAttempts = 0;
  //               _lockoutEnd = null;
  //             });
  //           }
  //         });

  //         showTopAlert(
  //           context,
  //           message:
  //               "Too many failed attempts. Please wait $_lockoutMinutes minutes before trying again.",
  //           color: AppDefaults.errorColor,
  //           icon: Iconsax.danger,
  //         );
  //         return;
  //       }

  //       final attemptsLeft = _maxAttempts - _loginAttempts;
  //       showTopAlert(
  //         context,
  //         message:
  //             "Incorrect email or password. $attemptsLeft attempt${attemptsLeft == 1 ? '' : 's'} remaining.",
  //         color: AppDefaults.errorColor,
  //         icon: Iconsax.danger,
  //       );
  //       setState(() => isSubmitting = false);
  //       return;
  //     }

  //     setState(() => isSubmitting = false);

  //     // Map all Firebase error codes to professional messages
  //     final message = _mapFirebaseError(e.code, e.message);
  //     showTopAlert(
  //       context,
  //       message: message,
  //       color: AppDefaults.errorColor,
  //       icon: Iconsax.danger,
  //     );
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}