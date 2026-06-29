import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/app-settings/custom_notification.dart';
import 'package:gymklout/app-settings/media.dart';
import 'package:gymklout/common/buttons/custom_button.dart';
import 'package:gymklout/common/buttons/icon_custom_button.dart';
import 'package:gymklout/common/text_fields/text_field.dart';
import 'package:gymklout/providers/auth_provider.dart';
import 'package:gymklout/screens/authentication/verify-email/verify_email.dart';
import 'package:gymklout/screens/authentication/welcome-back/welcome_back.dart';
import 'package:gymklout/services/api_service.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool buttonIsEnabled = false;

  @override
  void initState() {
    super.initState();
    fullNameController.addListener(_validate);
    emailController.addListener(_validate);
    passwordController.addListener(_validate);
    confirmPasswordController.addListener(_validate);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _validate() {
    final email = emailController.text.trim();
    final enable =
        fullNameController.text.trim().length >= 2 &&
        email.isNotEmpty &&
        email.contains('@') &&
        email.contains('.') &&
        passwordController.text.trim().isNotEmpty &&
        confirmPasswordController.text.trim().isNotEmpty;

    if (enable != buttonIsEnabled) {
      setState(() => buttonIsEnabled = enable);
    }
  }

  Future<void> _register() async {
    if (!buttonIsEnabled) return;
    HapticFeedback.lightImpact();

    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      showTopAlert(
        context,
        message: 'Passwords do not match.',
        type: AlertType.error,
      );
      return;
    }

    try {
      await ref
          .read(authProvider.notifier)
          .register(
            email: emailController.text.trim(),
            password: password,
            fullName: fullNameController.text.trim(),
          );

      if (!mounted) return;

      // Success — push to verify screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => VerifyEmailScreen(email: emailController.text.trim()),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      HapticFeedback.heavyImpact();

      // Account exists but unverified — send them to verify instead
      if (e is ApiException && e.statusCode == 409) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                VerifyEmailScreen(email: emailController.text.trim()),
          ),
        );
        return;
      }

      showTopAlert(context, message: e.toString(), type: AlertType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                      height: size.height * 0.45,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppMedia.onboarding5),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: AppDefaults.defaultPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(child: SizedBox()),
                            Text(
                              "Ready to",
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
                                            21) +
                                        20,
                                  ),
                            ),
                            Text(
                              "Transform?",
                              style:
                                  AppDefaults.headLiner1(
                                    context,
                                    fontWeight: FontWeight.w800,
                                  ).copyWith(
                                    color: Colors.white.withAlpha(210),
                                    fontSize:
                                        (AppDefaults.headLiner1(
                                              context,
                                            ).fontSize ??
                                            21) +
                                        26,
                                  ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Create your ${AppDefaults.appName} account and start your fitness journey.",
                              style: AppDefaults.textStyle(
                                context,
                                fontWeight: FontWeight.w400,
                              ).copyWith(color: Colors.white.withAlpha(210)),
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
                        children: [
                          // ── Login tab ──
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              Navigator.of(context).pop();
                            },
                            child: Text(
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
                          ),
                          const SizedBox(width: 15),
                          // ── Create Account tab (active) ──
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
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
                              const SizedBox(height: 5),
                              Container(
                                width: 150,
                                height: 3,
                                color: AppDefaults.primaryColor,
                              ),
                            ],
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
                      label: "Full Name",
                      hintText: "Your full name",
                      prefixIcon: null,
                      controller: fullNameController,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 5),
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
                    const SizedBox(height: 5),
                    CustomTextField(
                      label: "Confirm Password",
                      hintText: "Confirm Password",
                      prefixIcon: null,
                      passField: true,
                      controller: confirmPasswordController,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    SafeArea(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                "Create Account",
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
                                          2,
                                    ),
                              ),
                              icon: const Icon(
                                FluentIcons.arrow_right_12_regular,
                                size: 20,
                              ),
                              onSubmit: buttonIsEnabled && !isSubmitting
                                  ? _register
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
