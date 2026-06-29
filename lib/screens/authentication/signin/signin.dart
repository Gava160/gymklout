import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/app-settings/media.dart';
import 'package:gymklout/app-settings/custom_notification.dart';
import 'package:gymklout/common/buttons/custom_button.dart';
import 'package:gymklout/common/buttons/icon_custom_button.dart';
import 'package:gymklout/common/text_fields/text_field.dart';
import 'package:gymklout/providers/auth_provider.dart';
import 'package:gymklout/screens/authentication/forgot-password/forgot_password.dart';
import 'package:gymklout/screens/authentication/signup/signup.dart';
import 'package:gymklout/screens/authentication/verify-email/verify_email.dart';
import 'package:gymklout/screens/authentication/welcome-back/welcome_back.dart';
import 'package:gymklout/screens/bottom-navigation/bottom_nav_bar.dart';
import 'package:gymklout/screens/my-account/update-profile-avatar/profile_avatar.dart';
import 'package:gymklout/services/api_service.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool buttonIsEnabled = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_validate);
    passwordController.addListener(_validate);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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

  Future<void> _login() async {
    if (!buttonIsEnabled) return;
    HapticFeedback.lightImpact();

    await ref
        .read(authProvider.notifier)
        .login(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

    if (!mounted) return;

    final authState = ref.read(authProvider);

    authState.when(
      data: (state) {
        if (state is AuthAuthenticated) {
          final profile = state.data.user.profile;
          if (profile != null) {
            HapticFeedback.lightImpact();
            // Navigate to complete profile screen (step 2) - head home

            // if(!profile.completedProfileRegistration == false) {

            // }

            if (profile.avatarUrl != null) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const BottomNavBarController(),
                ),
                (route) => false,
              );
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const ProfileAvatarSetScreen(popAfterSuccess: false,),
                ),
                (route) => false,
              );
            }
          } else {
            showTopAlert(
              context,
              message: "Login failed: unknown error",
              type: AlertType.error,
            );
          }
        }
      },
      error: (e, _) {
        HapticFeedback.heavyImpact();
        // Unverified email — push to verify screen
        if (e is ApiException && e.statusCode == 403) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  VerifyEmailScreen(email: emailController.text.trim()),
            ),
          );
          return;
        }

        showTopAlert(context, message: e.toString(), type: AlertType.error);
      },
      loading: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Watch loading state to drive button
    final authState = ref.watch(authProvider);
    final isSubmitting = authState.isLoading;

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
                          image: AssetImage(AppMedia.onboarding4),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: AppDefaults.defaultPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Expanded(child: SizedBox()),
                            Text(
                              "Welcome back,",
                              style:
                                  AppDefaults.headLiner1(
                                    context,
                                    fontWeight: FontWeight.w200,
                                  ).copyWith(
                                    color: Colors.white,
                                    fontSize:
                                        (AppDefaults.headLiner1(
                                              context,
                                            ).fontSize ??
                                            21) +
                                        20,
                                  ),
                            ),
                            Text(
                              "GymRat",
                              style:
                                  AppDefaults.headLiner1(
                                    context,
                                    fontWeight: FontWeight.w800,
                                  ).copyWith(
                                    color: Colors.white,
                                    fontSize:
                                        (AppDefaults.headLiner1(
                                              context,
                                            ).fontSize ??
                                            21) +
                                        26,
                                  ),
                            ),
                            const SizedBox(height: 50),
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
                  SafeArea(
                    child: Padding(
                      padding: AppDefaults.defaultPadding,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // ── Login tab ──
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Login",
                                style:
                                    AppDefaults.headLiner1(
                                      context,
                                      fontWeight: FontWeight.w200,
                                    ).copyWith(
                                      color: Colors.white.withAlpha(210),
                                      fontSize:
                                          (AppDefaults.headLiner1(
                                                context,
                                              ).fontSize ??
                                              21) -
                                          2,
                                    ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 60,
                                height: 3,
                                color: AppDefaults.primaryColor,
                              ),
                            ],
                          ),
                          const SizedBox(width: 15),
                          // ── Create Account tab ──
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Create Account",
                              style:
                                  AppDefaults.headLiner1(
                                    context,
                                    fontWeight: FontWeight.w200,
                                  ).copyWith(
                                    color: Colors.white.withAlpha(210),
                                    fontSize:
                                        (AppDefaults.headLiner1(
                                              context,
                                            ).fontSize ??
                                            21) -
                                        2,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: AppDefaults.defaultPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      label: "Email address",
                      hintText: "Email",
                      prefixIcon: null,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      label: "Password",
                      hintText: "Password",
                      prefixIcon: null,
                      passField: true,
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style:
                              AppDefaults.textStyle(
                                context,
                                fontWeight: FontWeight.w400,
                              ).copyWith(
                                color: AppDefaults.primaryColor,
                                fontSize:
                                    AppDefaults.textStyle(context).fontSize ??
                                    16,
                              ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SafeArea(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: IconCustomButtonAuth(
                              noPadding: true,
                              fontAwesomeIcon: FontAwesomeIcons.google,
                              backgroundColor: AppDefaults.textColor.withAlpha(
                                40,
                              ),
                              foregroundColor: AppDefaults.textColor,
                              onSubmit: () {},
                            ),
                          ),
                          const SizedBox(width: 7),
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: IconCustomButtonAuth(
                              noPadding: true,
                              fontAwesomeIcon: FontAwesomeIcons.apple,
                              backgroundColor: AppDefaults.textColor.withAlpha(
                                40,
                              ),
                              foregroundColor: AppDefaults.textColor,
                              onSubmit: () {},
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: size.width * 0.50,
                            child: AppCustomButton(
                              noPadding: true,
                              isLoading: isSubmitting,
                              isDisabled: buttonIsEnabled,
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
                              icon: const Icon(
                                FluentIcons.arrow_right_12_regular,
                                size: 20,
                              ),
                              onSubmit: buttonIsEnabled && !isSubmitting
                                  ? _login
                                  : null,
                            ),
                          ),
                        ],
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
