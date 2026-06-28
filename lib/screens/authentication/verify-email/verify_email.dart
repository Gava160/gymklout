import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/app-settings/custom_notification.dart';
import 'package:gymklout/common/appbar.dart';
import 'package:gymklout/common/buttons/custom_button.dart';
import 'package:gymklout/providers/auth_provider.dart';
import 'package:gymklout/screens/bottom-navigation/bottom_nav_bar.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isSubmitting = false;
  bool _isResending = false;

  // Resend cooldown
  int _resendCooldown = 0;

  String get _otpCode => _otpControllers.map((c) => c.text).join();
  bool get _otpComplete => _otpCode.length == 6;

  @override
  void dispose() {
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  // ─── Verify OTP ─────────────────────────────────────────────────────────────
  Future<void> _verify() async {
    if (!_otpComplete || _isSubmitting) return;
    HapticFeedback.lightImpact();

    setState(() => _isSubmitting = true);

    try {
      final result = await ref
          .read(authProvider.notifier)
          .verifyOtp(email: widget.email, token: _otpCode);

      if (!mounted) return;

      showTopAlert(context, message: result.message, type: AlertType.success);

      // Small delay so alert is visible before navigating
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;

      // If verifyOtp returns a session, user is now logged in
      // Navigate based on profile completion
      if (result.accessToken.isNotEmpty) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const BottomNavBarController()),
          (route) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      HapticFeedback.heavyImpact();
      showTopAlert(context, message: e.toString(), type: AlertType.error);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ─── Resend OTP ──────────────────────────────────────────────────────────────
  Future<void> _resend() async {
    if (_isResending || _resendCooldown > 0) return;
    HapticFeedback.selectionClick();

    setState(() => _isResending = true);

    try {
      await ref
          .read(authProvider.notifier)
          .resendVerification(email: widget.email);

      if (!mounted) return;

      showTopAlert(
        context,
        message: 'Verification code resent to ${widget.email}',
        type: AlertType.success,
      );

      // Start 60s cooldown
      setState(() => _resendCooldown = 60);
      _startCooldown();

      // Clear OTP boxes
      for (final c in _otpControllers) {
        c.clear();
      }
      _focusNodes.first.requestFocus();
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      showTopAlert(context, message: e.toString(), type: AlertType.error);
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  void _startCooldown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _resendCooldown--);
      return _resendCooldown > 0;
    });
  }

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
          preferredSize: const Size.fromHeight(kTextTabBarHeight + 35),
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
                  child: Padding(
                    padding: AppDefaults.defaultPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Verification",
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
                                    (AppDefaults.headLiner1(context).fontSize ??
                                        21) +
                                    10,
                              ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "We sent a 6-digit code to ${widget.email}. Enter it below to verify your account.",
                          style:
                              AppDefaults.textStyle(
                                context,
                                fontWeight: FontWeight.w400,
                              ).copyWith(
                                color: getDefaultHeaderColor(
                                  context,
                                  lightAlpha: 120,
                                ),
                              ),
                        ),
                        const SizedBox(height: 40),

                        // ── OTP Boxes ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) {
                            return _OtpBox(
                              controller: _otpControllers[index],
                              focusNode: _focusNodes[index],
                              onChanged: (val) {
                                if (val.isNotEmpty && index < 5) {
                                  _focusNodes[index + 1].requestFocus();
                                }
                                if (val.isEmpty && index > 0) {
                                  _focusNodes[index - 1].requestFocus();
                                }
                                setState(() {});
                              },
                            );
                          }),
                        ),
                        const SizedBox(height: 28),

                        // ── Resend row ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive a code? ",
                              style:
                                  AppDefaults.textStyle(
                                    context,
                                    fontWeight: FontWeight.w400,
                                  ).copyWith(
                                    color: getDefaultHeaderColor(
                                      context,
                                      lightAlpha: 100,
                                    ),
                                    fontSize: 14,
                                  ),
                            ),
                            GestureDetector(
                              onTap: _resendCooldown > 0 ? null : _resend,
                              child: _isResending
                                  ? SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                        color: AppDefaults.primaryColor,
                                      ),
                                    )
                                  : Text(
                                      _resendCooldown > 0
                                          ? "Resend in ${_resendCooldown}s"
                                          : "Resend",
                                      style:
                                          AppDefaults.textStyle(
                                            context,
                                            fontWeight: FontWeight.w700,
                                          ).copyWith(
                                            color: _resendCooldown > 0
                                                ? AppDefaults.textColor
                                                : AppDefaults.primaryColor,
                                            fontSize: 14,
                                          ),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Bottom actions ──
              Padding(
                padding: AppDefaults.defaultPadding,
                child: SafeArea(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Try another way",
                          style: AppDefaults.textStyle(
                            context,
                            fontWeight: FontWeight.w600,
                          ).copyWith(color: AppDefaults.primaryColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: size.width * 0.70,
                        child: AppCustomButton(
                          noPadding: true,
                          isLoading: _isSubmitting,
                          label: Text(
                            "Verify",
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
                          onSubmit: _otpComplete && !_isSubmitting
                              ? _verify
                              : null,
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

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isFilled = controller.text.isNotEmpty;

    return SizedBox(
      width: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 44,
            height: 56,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.number,
              maxLength: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.transparent),
              cursorColor: Colors.transparent,
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                fillColor: Colors.transparent,
                filled: true,
              ),
              onChanged: onChanged,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isFilled
                  ? Text(
                      controller.text,
                      style:
                          AppDefaults.headLiner1(
                            context,
                            fontWeight: FontWeight.w700,
                          ).copyWith(
                            color: getDefaultHeaderColor(context),
                            fontSize: 28,
                          ),
                    )
                  : Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppDefaults.textColor.withAlpha(100),
                        shape: BoxShape.circle,
                      ),
                    ),
              const SizedBox(height: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 36,
                height: 2.5,
                decoration: BoxDecoration(
                  color: isFilled
                      ? AppDefaults.primaryColor
                      : AppDefaults.textColor.withAlpha(60),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
