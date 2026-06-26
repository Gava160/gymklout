import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/common/appbar.dart';
import 'package:gymklout/common/buttons/custom_button.dart';
import 'package:gymklout/common/text_fields/text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  bool isSubmitting = false;
  bool buttonIsEnabled = false;

  // int _loginAttempts = 0;
  // bool _isLockedOut = false;
  // DateTime? _lockoutEnd;
  // static const int _maxAttempts = 2;
  // static const int _lockoutMinutes = 5;

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    emailController.addListener(_validate);
    super.initState();
  }

  void _validate() {
    final email = emailController.text.trim();
    final enable =
        email.isNotEmpty && email.contains('@') && email.contains('.');

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
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        backgroundColor: getDefaultBgColor(context),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kTextTabBarHeight + 35),
          child: SafeArea(
            child: Padding(
              padding: AppDefaults.defaultPadding,
              child: CustomAppBar(title: "", actions: []),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: AppDefaults.defaultPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Forgot Password?",
                              style:
                                  AppDefaults.headLiner1(
                                    context,
                                    fontWeight: FontWeight.w600,
                                  ).copyWith(
                                    color: getDefaultHeaderColor(
                                      context,
                                      lightAlpha: 180,
                                    ),
                                    fontSize:
                                        (AppDefaults.headLiner1(
                                              context,
                                            ).fontSize ??
                                            21) +
                                        10,
                                  ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Enter the email address attached to your account, \nan OTP will be sent to you.",
                              style:
                                  AppDefaults.textStyle(
                                    context,
                                    fontWeight: FontWeight.w400,
                                  ).copyWith(
                                    color: getDefaultHeaderColor(
                                      context,
                                      lightAlpha: 120,
                                    ),
                                    fontSize:
                                        (AppDefaults.textStyle(
                                          context,
                                        ).fontSize ??
                                        21),
                                  ),
                            ),
                            SizedBox(height: 10),
                            CustomTextField(
                              label: "Email address",
                              hintText: "Email",
                              prefixIcon: null,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                        },
                        child: Text(
                          "Try another way",
                          style:
                              AppDefaults.textStyle(
                                context,
                                fontWeight: FontWeight.w600,
                              ).copyWith(
                                color: AppDefaults.primaryColor,
                                fontSize:
                                    (AppDefaults.textStyle(context).fontSize ??
                                    21),
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: size.width * 0.70,
                        child: AppCustomButton(
                          noPadding: true,
                          label: Text(
                            "Send",
                            style:
                                AppDefaults.textStyle(
                                  context,
                                  fontWeight: FontWeight.w800,
                                ).copyWith(
                                  color: AppDefaults.white,
                                  fontSize:
                                      (AppDefaults.textStyle(
                                            context,
                                          ).fontSize ??
                                          16) +
                                      4,
                                ),
                          ),
                          onSubmit: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
