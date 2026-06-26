import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/media.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/screens/onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    if (!hasSeenOnboarding) {
      await prefs.setBool('hasSeenOnboarding', true);
      _navigateTo(const OnboardingScreen());
      return;
    }

  }

  void _navigateTo(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
    // animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppDefaults.darkBgColor : AppDefaults.white,
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 40,
                child: showSpinner(
                  scale: 1.05,
                  androidOnly: false,
                  androidStrokeWidth: 4,
                ),
              ),
              SizedBox(height: 14),
            ],
          ),
        ),
      ),
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                isDark ? AppMedia.logoWhite : AppMedia.logoBlack,
                width: MediaQuery.of(context).size.width * 0.60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
