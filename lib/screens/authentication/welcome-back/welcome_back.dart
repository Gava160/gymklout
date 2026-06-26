import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/app-settings/media.dart';
import 'package:gymklout/common/buttons/custom_button.dart';
import 'package:gymklout/common/buttons/icon_custom_button.dart';
import 'package:gymklout/common/text_fields/text_field.dart';

class WelcomeBackScreen extends StatefulWidget {
  const WelcomeBackScreen({super.key});
  @override
  State<WelcomeBackScreen> createState() => _WelcomeBackScreenState();
}

class _WelcomeBackScreenState extends State<WelcomeBackScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        backgroundColor: getDefaultBgColor(context),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: SlantedBottomClipper(),
                    child: Container(
                      width: double.infinity,
                      height: size.height * 0.60,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppMedia.onboarding3),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: AppDefaults.defaultPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(child: SizedBox()),
                            Text(
                              "Welcome back,",
                              style:
                                  AppDefaults.headLiner1(
                                    context,
                                    fontWeight: FontWeight.w200,
                                  ).copyWith(
                                    color: getDefaultHeaderColor(context),
                                    fontSize:
                                        (AppDefaults.headLiner1(
                                              context,
                                            ).fontSize ??
                                            21) +
                                        20,
                                  ),
                            ),
                            Text(
                              "Juietta",
                              style:
                                  AppDefaults.headLiner1(
                                    context,
                                    fontWeight: FontWeight.w800,
                                  ).copyWith(
                                    color: getDefaultHeaderColor(context),
                                    fontSize:
                                        (AppDefaults.headLiner1(
                                              context,
                                            ).fontSize ??
                                            21) +
                                        26,
                                  ),
                            ),
                            SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: ClipPath(
                      clipper: SlantedBottomClipper(),
                      child: Container(
                        color: AppDefaults.darkBgColor.withAlpha(170),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: AppDefaults.defaultPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomTextField(
                      label: "Email address",
                      hintText: "Email",
                      prefixIcon: null,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 5),
                    CustomTextField(
                      label: "Password",
                      hintText: "Password",
                      prefixIcon: null,
                      passField: true,
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Forget Password?",
                        style:
                            AppDefaults.textStyle(
                              context,
                              fontWeight: FontWeight.w400,
                            ).copyWith(
                              color: AppDefaults.primaryColor,
                              fontSize:
                                  (AppDefaults.textStyle(context).fontSize ??
                                  21),
                            ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: IconCustomButtonAuth(
                                noPadding: true,
                                fontAwesomeIcon: FontAwesomeIcons.google,
                                backgroundColor: AppDefaults.textColor.withAlpha(40),
                                foregroundColor:AppDefaults.textColor,
                                onSubmit: () {},
                              ),
                            ),
                            SizedBox(width: 7,),
                             SizedBox(
                              width: 60,
                              height: 60,
                              child: IconCustomButtonAuth(
                                noPadding: true,
                                fontAwesomeIcon: FontAwesomeIcons.apple,
                                backgroundColor: AppDefaults.textColor.withAlpha(40),
                                foregroundColor:AppDefaults.textColor,
                                onSubmit: () {},
                              ),
                            ),
                            Spacer(),

                            SizedBox(
                              width: size.width * 0.50,
                              child: AppCustomButton(
                                noPadding: true,
                                label: Text(
                                  "Login",
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
                                icon: Icon(
                                  FluentIcons.arrow_right_12_regular,
                                  size: 20,
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
            ],
          ),
        ),
      ),
    );
  }
}

class SlantedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height); // bottom-left point (pulled up)
    path.lineTo(
      size.width,
      size.height - 70,
    ); // bottom-right point (full height)
    path.lineTo(size.width, 0); // top-right
    path.close(); // back to top-left

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
